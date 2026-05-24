// ============================================================
// Autor: Edson Joel Carrera Avila
// main.cpp
// ============================================================

#include <cstdio>                                      
#include <intrin.h>                                    

extern "C" float productoPunto_fpu(const float*, const float*, size_t);
extern "C" float productoPunto_sse(const float*, const float*, size_t);
extern "C" float productoPunto_avx(const float*, const float*, size_t);

int main() {
    // --- Reserva de los vectores con alineación de 32 bytes ---
    // alignas(32) garantiza que la dirección de A y B sea múltiplo de 32.
    // 'static' los coloca en el segmento de datos, no en la pila, lo que
    // facilita la alineación para arreglos grandes.
    alignas(32) static float A[1000];
    alignas(32) static float B[1000];

    // --- Inicialización de los vectores ---
    for (int i = 0; i < 1000; i++) {
        A[i] = 1.5f;
        B[i] = 2.0f;
    }

    // --- Tabla de rutinas a comparar ---
    using Func = float(*)(const float*, const float*, size_t);
    Func rutinas[]        = { productoPunto_fpu, productoPunto_sse, productoPunto_avx };
    const char* nombres[] = { "FPU",             "SSE",             "AVX"             };

    printf("Calculando Producto Punto (N = 1000)\n");
    printf("--------------------------------------------------\n");

    // --- Bucle de medición ---
    for (int i = 0; i < 3; i++) {
        // 1) Calentamiento de caché: una invocación previa carga los vectores
        //    en L1/L2 y resuelve el TLB. Sin esto, la primera medición sería
        //    artificialmente lenta por fallos de caché.
        rutinas[i](A, B, 1000);

        // 2) Barrera ANTES de leer el contador.
        //    _mm_lfence() impide que instrucciones posteriores se ejecuten
        //    antes de que termine la barrera (serialización de carga).
        _mm_lfence();
        unsigned __int64 inicio = __rdtsc();             // Lee el contador de ciclos del procesador (TSC)
        _mm_lfence();                                    // Otra barrera para asegurar que __rdtsc completó antes de la rutina

        // 3) Llamada a la rutina ensamblador medida
        float res = rutinas[i](A, B, 1000);

        _mm_lfence();                                    // Barrera de salida: asegura que la rutina terminó antes del __rdtsc final
        unsigned __int64 ciclos = __rdtsc() - inicio;    // Ciclos transcurridos

        // 4) Resultado: se imprime el valor calculado y el costo en ciclos.
        printf("%s | Res: %.1f | Tiempo: %llu ciclos\n", nombres[i], res, ciclos);
    }

    printf("--------------------------------------------------\n");
    return 0;
}