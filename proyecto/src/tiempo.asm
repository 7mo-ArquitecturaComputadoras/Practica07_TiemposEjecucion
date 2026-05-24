; tiempo.asm
; Ensamblador nativo de Windows (MASM x64)

PUBLIC productoPunto_fpu
PUBLIC productoPunto_sse
PUBLIC productoPunto_avx

.code

; ==========================================================
; FPU (x87)
; RCX = vecA, RDX = vecB, R8 = N
; ==========================================================
productoPunto_fpu PROC
    xor r9, r9                  ; Índice i = 0
    fldz                        ; st(0) = 0.0
L1_fpu:
    cmp r9, r8
    jge L2_fpu
    fld DWORD PTR [rcx + r9*4]  ; Carga float de vecA
    fmul DWORD PTR [rdx + r9*4] ; Multiplica por float de vecB
    faddp st(1), st(0)          ; Acumula y saca de la pila
    inc r9
    jmp L1_fpu
L2_fpu:
    sub rsp, 8                  ; Reserva espacio en pila (alineado a 8 bytes)
    fstp DWORD PTR [rsp]        ; Guarda el resultado en la pila
    movss xmm0, DWORD PTR [rsp] ; Pasa el resultado a XMM0 para retornar a C++
    add rsp, 8                  ; Restaura la pila
    ret
productoPunto_fpu ENDP

; ==========================================================
; SSE (SIMD 128-bits)
; RCX = vecA, RDX = vecB, R8 = N
; ==========================================================
productoPunto_sse PROC
    xorps xmm0, xmm0
    xor r9, r9
L1_sse:
    cmp r9, r8
    jge L2_sse
    ; Carga y multiplica 4 floats directamente desde memoria (XMMWORD = 128 bits)
    movaps xmm1, XMMWORD PTR [rcx + r9*4]
    mulps xmm1, XMMWORD PTR [rdx + r9*4]
    addps xmm0, xmm1
    add r9, 4
    jmp L1_sse
L2_sse:
    ; Suma horizontal
    haddps xmm0, xmm0
    haddps xmm0, xmm0
    ret
productoPunto_sse ENDP

; ==========================================================
; AVX (SIMD 256-bits)
; RCX = vecA, RDX = vecB, R8 = N
; ==========================================================
productoPunto_avx PROC
    vxorps ymm0, ymm0, ymm0
    xor r9, r9
L1_avx:
    cmp r9, r8
    jge L2_avx
    ; Carga y multiplica 8 floats (YMMWORD = 256 bits)
    vmovaps ymm1, YMMWORD PTR [rcx + r9*4]
    vmulps ymm1, ymm1, YMMWORD PTR [rdx + r9*4]
    vaddps ymm0, ymm0, ymm1
    add r9, 8
    jmp L1_avx
L2_avx:
    ; Reduce los 256 bits a 128 bits
    vextractf128 xmm1, ymm0, 1
    vaddps xmm0, xmm0, xmm1
    ; Suma horizontal
    vhaddps xmm0, xmm0, xmm0
    vhaddps xmm0, xmm0, xmm0
    vzeroupper                  ; Limpia el estado AVX
    ret
productoPunto_avx ENDP

END