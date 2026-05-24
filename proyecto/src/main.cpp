#include <cstdio>
#include <intrin.h> // Intrínsecos nativos para Windows MSVC

extern "C" float productoPunto_fpu(const float*, const float*, size_t);
extern "C" float productoPunto_sse(const float*, const float*, size_t);
extern "C" float productoPunto_avx(const float*, const float*, size_t);

int main() {
    // Asegura la alineación de 32 bytes en Windows
    alignas(32) static float A[1000];
    alignas(32) static float B[1000];

    // Inicialización: Resultado esperado = 3000.0
    for (int i = 0; i < 1000; i++) {
        A[i] = 1.5f;
        B[i] = 2.0f;
    }

    // Arreglo de punteros a funciones para no repetir código
    using Func = float(*)(const float*, const float*, size_t);
    Func rutinas[] = { productoPunto_fpu, productoPunto_sse, productoPunto_avx };
    const char* nombres[] = { "FPU", "SSE", "AVX" };

    printf("Calculando Producto Punto (N = 1000)\n");
    printf("--------------------------------------------------\n");

    for (int i = 0; i < 3; i++) {
        // Calentamiento rápido de la caché
        rutinas[i](A, B, 1000);

        _mm_lfence();
        unsigned __int64 inicio = __rdtsc();
        _mm_lfence();

        float res = rutinas[i](A, B, 1000);

        _mm_lfence();
        unsigned __int64 ciclos = __rdtsc() - inicio;

        printf("%s | Res: %.1f | Tiempo: %llu ciclos\n", nombres[i], res, ciclos);
    }

    printf("--------------------------------------------------\n");
    return 0;
}