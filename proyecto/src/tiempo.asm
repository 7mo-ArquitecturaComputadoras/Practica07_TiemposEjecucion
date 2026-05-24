; ============================================================
; Autor: Edson Joel Carrera Avila
; tiempo.asm
; ============================================================

PUBLIC productoPunto_fpu                           
PUBLIC productoPunto_sse                        
PUBLIC productoPunto_avx                     

.code                                       

; ==========================================================
; FPU (x87)
; Convención de llamadas Microsoft x64:
;   RCX = puntero a vecA (const float*)
;   RDX = puntero a vecB (const float*)
;   R8  = N (size_t, número de elementos)
; Procesa UN float por iteración usando la pila de la FPU.
; ==========================================================
productoPunto_fpu PROC
    xor  r9, r9                                         ; r9 = índice i = 0 (xor de un registro consigo mismo lo pone a 0 sin tocar flags relevantes)
    fldz                                                ; Apila 0.0 en la FPU. ST(0) = 0.0 (acumulador del producto punto)
L1_fpu:
    cmp  r9, r8                                         ; ¿i == N? Compara índice contra dimensión
    jge  L2_fpu                                         ; Si i >= N, sale del bucle (jge porque size_t no es negativo)
    fld  DWORD PTR [rcx + r9*4]                         ; Carga vecA[i] en la pila FPU. ST(0)=vecA[i], ST(1)=acum
                                                        ; r9*4 porque cada float ocupa 4 bytes
    fmul DWORD PTR [rdx + r9*4]                         ; Multiplica ST(0) por vecB[i] desde memoria. ST(0)=vecA[i]*vecB[i]
    faddp st(1), st(0)                                  ; Suma ST(0) a ST(1) y hace pop. ST(0)=acumulador actualizado
    inc  r9                                             ; i++
    jmp  L1_fpu                                         ; Repite el bucle
L2_fpu:
    sub  rsp, 8                                         ; Reserva 8 bytes en la pila (alineación de 8 bytes en x64)
    fstp DWORD PTR [rsp]                                ; Guarda ST(0) (el resultado) en la pila como float y hace pop
    movss xmm0, DWORD PTR [rsp]                         ; Carga el float de la pila a XMM0 (registro de retorno de floats en x64)
    add  rsp, 8                                         ; Libera los 8 bytes reservados
    ret                                                 ; Retorna a main.cpp con el resultado en XMM0
productoPunto_fpu ENDP

; ==========================================================
; SSE (SIMD 128-bits)
; Procesa CUATRO floats por iteración usando registros XMM
; (XMM0..XMM15 son de 128 bits = 4 floats).
; Requiere que los arreglos estén alineados a 16 bytes
; ==========================================================
productoPunto_sse PROC
    xorps xmm0, xmm0                                    ; Acumulador SIMD = (0.0, 0.0, 0.0, 0.0). xorps es la versión empaquetada de single-precision
    xor   r9, r9                                        ; i = 0
L1_sse:
    cmp  r9, r8                                         ; ¿i == N?
    jge  L2_sse                                         ; Si i >= N, salimos del bucle
    movaps xmm1, XMMWORD PTR [rcx + r9*4]               ; Carga 4 floats consecutivos de vecA a XMM1 (movaps = move aligned packed single)
    mulps  xmm1, XMMWORD PTR [rdx + r9*4]               ; Multiplica los 4 floats por los 4 floats correspondientes de vecB
    addps  xmm0, xmm1                                   ; Acumula los 4 productos parciales en XMM0
    add  r9, 4                                          ; Avanza el índice 4 elementos
    jmp  L1_sse                                         ; Repite el bucle
L2_sse:
    ; --- Reducción horizontal ---
    ; XMM0 contiene 4 sumas parciales [a, b, c, d]
    ; Necesitamos a + b + c + d como un escalar
    haddps xmm0, xmm0                                   ; haddps suma pares adyacentes: XMM0 = [a+b, c+d, a+b, c+d]
    haddps xmm0, xmm0                                   ; Segunda pasada: XMM0 = [a+b+c+d, a+b+c+d, a+b+c+d, a+b+c+d]
    ret                                                 ; Retorna con el resultado escalar en la parte baja de XMM0
productoPunto_sse ENDP

; ==========================================================
; AVX (SIMD 256-bits)
; Procesa OCHO floats por iteración usando registros YMM
; (YMM0..YMM15 son de 256 bits = 8 floats).
; Requiere que los arreglos estén alineados a 32 bytes
; ==========================================================
productoPunto_avx PROC
    vxorps ymm0, ymm0, ymm0                             ; Acumulador YMM = 8 ceros (vxorps usa la sintaxis VEX de 3 operandos)
    xor    r9, r9                                       ; i = 0
L1_avx:
    cmp  r9, r8                                         ; ¿i == N?
    jge  L2_avx                                         ; Si i >= N, salimos del bucle
    vmovaps ymm1, YMMWORD PTR [rcx + r9*4]              ; Carga 8 floats consecutivos de vecA a YMM1 (vmovaps = AVX move aligned packed single)
    vmulps  ymm1, ymm1, YMMWORD PTR [rdx + r9*4]        ; Multiplica los 8 floats por los 8 floats de vecB (3 operandos: dst, src1, src2)
    vaddps  ymm0, ymm0, ymm1                            ; Acumula los 8 productos parciales en YMM0
    add  r9, 8                                          ; Avanza el índice 8 elementos
    jmp  L1_avx                                         ; Repite el bucle
L2_avx:
    ; --- Reducción horizontal de 256 a 128 bits ---
    ; YMM0 = [a, b, c, d, e, f, g, h] (8 sumas parciales)
    vextractf128 xmm1, ymm0, 1                          ; Extrae la mitad alta de YMM0 a XMM1. XMM1 = [e, f, g, h]
    vaddps  xmm0, xmm0, xmm1                            ; Suma las dos mitades. XMM0 = [a+e, b+f, c+g, d+h]
    ; --- Reducción horizontal de 128 bits a escalar ---
    vhaddps xmm0, xmm0, xmm0                            ; Suma pares adyacentes. XMM0 = [a+e+b+f, c+g+d+h, a+e+b+f, c+g+d+h]
    vhaddps xmm0, xmm0, xmm0                            ; Segunda pasada. XMM0 = [total, total, total, total]
    vzeroupper                                          ; Limpia la mitad alta de los registros YMM para evitar penalización de transición AVX→SSE
    ret                                                 ; Retorna con el resultado escalar en la parte baja de XMM0
productoPunto_avx ENDP

END