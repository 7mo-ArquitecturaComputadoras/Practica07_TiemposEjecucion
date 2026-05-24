# 🔢 Práctica 07 — Tiempos de Ejecución: Producto Punto en FPU, SSE y AVX

Programa mixto **ensamblador x64 (MASM) + C++** que compara los tiempos de ejecución de **tres implementaciones equivalentes** del producto punto entre vectores de `float`: una con la **FPU x87** (un dato por iteración), otra con **SSE** (cuatro `float` en paralelo, 128 bits) y la tercera con **AVX** (ocho `float` en paralelo, 256 bits). La medición se realiza con la instrucción `RDTSC` envuelta en barreras `LFENCE` para obtener el conteo de ciclos del procesador con precisión.

---

## 📑 Índice

- [🎯 ¿Qué hace el programa?](#-qué-hace-el-programa)
- [🧠 Idea central del experimento](#-idea-central-del-experimento)
- [📂 Estructura del repositorio](#-estructura-del-repositorio)
- [🚀 Cómo empezar](#-cómo-empezar)
- [🔍 Trazado del experimento `N=1000`](#-trazado-del-experimento-n1000)
- [📘 Instrucciones x86/x64 utilizadas](#-instrucciones-x86x64-utilizadas)
- [📄 Documentación adicional](#-documentación-adicional)

---

## 🎯 ¿Qué hace el programa?

El programa inicializa dos vectores de `1000` elementos `float` (`A[i] = 1.5`, `B[i] = 2.0`) y calcula su **producto punto** tres veces consecutivas, una por cada tecnología SIMD, midiendo el costo de cada llamada en **ciclos del procesador**.

La operación implementada es la misma en las tres rutinas:

```
A · B = Σ A[i] * B[i]   para i = 0, 1, ..., N-1
```

Para los datos elegidos:
- `A[i] * B[i] = 1.5 * 2.0 = 3.0`
- Suma: `1000 * 3.0 = 3000.0`

Las tres rutinas deben devolver **exactamente** `3000.0`; lo que cambia es **cuántos ciclos** consumen para llegar al resultado. La salida típica es similar a:

```
FPU | Res: 3000.0 | Tiempo: XXXX ciclos
SSE | Res: 3000.0 | Tiempo:  YYY ciclos
AVX | Res: 3000.0 | Tiempo:   ZZ ciclos
```

con la jerarquía esperada `FPU > SSE > AVX` (de más lento a más rápido).

---

## 🧠 Idea central del experimento

Las tres rutinas comparten el mismo trabajo lógico (1000 multiplicaciones y 1000 sumas), pero difieren en **cuántos elementos procesan por iteración** del bucle:

| Tecnología | Ancho del registro | `float` por iter. | Iteraciones (N=1000) |
|------------|--------------------|--------------------|----------------------|
| FPU x87    | 80 bits (escalar)  | 1                  | 1000                 |
| SSE        | 128 bits (XMM)     | 4                  | 250                  |
| AVX        | 256 bits (YMM)     | 8                  | 125                  |

Cuantos menos pases del bucle haga el procesador, menos instrucciones decodifica y menos saltos predice, lo que se traduce en menos ciclos consumidos.

### Cómo se mide el tiempo

```
LFENCE             ; barrera: asegura que terminen las cargas anteriores
RDTSC → t0         ; lee el contador de ciclos del procesador
LFENCE             ; barrera: la rutina no empieza antes de t0
   rutina()        ; ← se mide esto
LFENCE             ; barrera: la rutina termina antes del segundo RDTSC
RDTSC → t1
ciclos = t1 - t0
```

Sin las barreras `LFENCE`, el procesador podría reordenar las instrucciones y mover `RDTSC` antes o después de la rutina, falseando la medición.

### Por qué el calentamiento de caché es necesario

La primera invocación a una rutina carga los vectores `A` y `B` desde la RAM hasta la caché L1, lo que añade un costo de cientos de ciclos que no es representativo del algoritmo. Por eso, antes de la medición real, el programa hace una llamada de calentamiento que **descartamos** para que la medición final refleje únicamente el costo del cálculo, no el del acceso a memoria.

---

## 📂 Estructura del repositorio

```
Practica07_TiemposEjecucion/
├── documentacion/
│   ├── README_compilacion_latex.md             # Cómo compilar el .tex a PDF
│   ├── reporte.pdf                             # Reporte técnico compilado
│   ├── reporte.tex                             # Reporte técnico en LaTeX
│   └── imagenes/                               # Imágenes usadas en el reporte
│
├── proyecto/
│   ├── README_instalacion.md                   # Guía de instalación y puesta en marcha
│   ├── Practica07_TiemposEjecucion.slnx        # Solución de Visual Studio
│   ├── Practica07_TiemposEjecucion.vcxproj     # Proyecto MSBuild + MASM (x64)
│   └── src/
│       ├── tiempo.asm                          # Tres rutinas en ensamblador x64 (FPU, SSE, AVX)
│       └── main.cpp                            # Programa principal con RDTSC + LFENCE
│
├── .gitattributes                              # Normalización de finales de línea
├── .gitignore                                  # Archivos ignorados por Git
└── README.md                                   # Este archivo
```

---

## 🚀 Cómo empezar

La guía detallada con todos los pasos (instalar Git, Visual Studio, habilitar MASM, configurar la plataforma x64, compilar en Release y ejecutar) está en un documento aparte:

➡️ **[Guía de instalación y puesta en marcha](proyecto/README_instalacion.md)**

Resumen rápido para quien ya tiene el entorno listo:

1. Abre el **Símbolo del sistema** (`cmd`) o **Git Bash**, ubícate en la carpeta donde quieras guardar el proyecto y ejecuta:

```bash
git clone git@github.com:7mo-ArquitecturaComputadoras/Practica07_TiemposEjecucion.git
```

2. Abrir `proyecto/Practica07_TiemposEjecucion.slnx` en Visual Studio.
3. Seleccionar configuración **Release | x64** (importante: x64, no Win32).
4. Compilar con `Ctrl + Shift + B` y ejecutar con `Ctrl + F5`.
5. Observar los ciclos consumidos por cada rutina en la consola.

---

## 🔍 Trazado del experimento `N=1000`

### Trabajo lógico (constante para las tres rutinas)

| Vector A | Vector B | Producto | Suma final |
|----------|----------|----------|------------|
| `1.5`    | `2.0`    | `3.0`    | `1000 × 3.0 = 3000.0` |

### Comparativa de iteraciones y *speedup* teórico

| Rutina | `float` por iteración | Iteraciones | Speedup teórico |
|--------|------------------------|-------------|-----------------|
| FPU x87 | 1 | 1000 | `1×` (referencia)  |
| SSE     | 4 | 250  | `4×`               |
| AVX     | 8 | 125  | `8×`               |

### Estado del acumulador SIMD para AVX (8 carriles)

| Iteración | `YMM1` (carga)               | `YMM0` (acumulador)         |
|-----------|------------------------------|------------------------------|
| inicial   | —                            | `[0, 0, 0, 0, 0, 0, 0, 0]`  |
| 1         | `[3, 3, 3, 3, 3, 3, 3, 3]`   | `[3, 3, 3, 3, 3, 3, 3, 3]`  |
| 2         | `[3, 3, 3, 3, 3, 3, 3, 3]`   | `[6, 6, 6, 6, 6, 6, 6, 6]`  |
| ...       | ...                          | ...                          |
| 125       | `[3, 3, 3, 3, 3, 3, 3, 3]`   | `[375, 375, 375, 375, 375, 375, 375, 375]` |

Tras el bucle, la **reducción horizontal** (`VEXTRACTF128 + VADDPS + VHADDPS + VHADDPS`) suma los 8 carriles: `375 × 8 = 3000.0`.

El *speedup* medido en la práctica suele ser **menor que el teórico** por la latencia inherente de las instrucciones SIMD, el costo fijo de la reducción horizontal y el ancho de banda de la caché L1.

---

## 📘 Instrucciones x86/x64 utilizadas

### FPU x87 (un dato por iteración)

| Instrucción | Operación                                                              |
|-------------|------------------------------------------------------------------------|
| `FLDZ`      | Carga `0.0` al tope de la pila FPU                                     |
| `FLD`       | Carga un `float` (4 bytes) desde memoria a `ST(0)`                     |
| `FMUL`      | Multiplica `ST(0)` por un operando de memoria                          |
| `FADDP`     | Suma `ST(0)` a `ST(1)` y hace *pop*                                    |
| `FSTP`      | Guarda `ST(0)` en memoria y hace *pop*                                 |
| `MOVSS`     | Copia un `float` escalar entre memoria y un registro XMM (retorno)     |

### SSE (128 bits, 4 `float` empaquetados)

| Instrucción | Operación                                                          |
|-------------|--------------------------------------------------------------------|
| `XORPS`     | Limpia un registro XMM (acumulador a cero)                         |
| `MOVAPS`    | Carga 4 `float` alineados desde memoria a un registro XMM          |
| `MULPS`     | Multiplica 4 `float` por 4 `float`, elemento a elemento            |
| `ADDPS`     | Suma 4 `float` con 4 `float`                                       |
| `HADDPS`    | Suma horizontal: combina pares adyacentes dentro de un XMM         |

### AVX (256 bits, 8 `float` empaquetados)

| Instrucción       | Operación                                                                  |
|-------------------|----------------------------------------------------------------------------|
| `VXORPS`          | Limpia un registro YMM completo (acumulador a cero)                        |
| `VMOVAPS`         | Carga 8 `float` alineados a 32 bytes desde memoria                         |
| `VMULPS`          | Multiplica 8 `float` por 8 `float`                                         |
| `VADDPS`          | Suma 8 `float` con 8 `float`                                               |
| `VEXTRACTF128`    | Extrae la mitad alta de un YMM a un XMM (reduce 256→128 bits)              |
| `VHADDPS`         | Suma horizontal AVX                                                        |
| `VZEROUPPER`      | Limpia la mitad alta de los registros YMM (evita penalización AVX→SSE)     |

### Propósito general e instrumentación

| Instrucción    | Operación                                                                 |
|----------------|---------------------------------------------------------------------------|
| `XOR`          | `XOR r, r` pone un registro a `0` sin tocar flags relevantes              |
| `CMP` / `JGE`  | Compara el índice contra `N` y salta cuando el bucle termina              |
| `INC` / `ADD`  | Avanza el índice de iteración (1, 4 u 8 elementos según la rutina)        |
| `JMP`          | Vuelve al inicio del bucle                                                |
| `RET`          | Retorna al llamador con el resultado en `XMM0`                            |
| `RDTSC`        | Lee el contador de ciclos del procesador (instrumentación, no en `.asm`)  |
| `LFENCE`       | Serializa la ejecución para que `RDTSC` no se reordene                    |

---

## 📄 Documentación adicional

| Documento | Descripción |
|---|---|
| 🛠️ [`README_instalacion.md`](proyecto/README_instalacion.md) | Cómo instalar Git, Visual Studio con MASM, configurar la plataforma x64 y ejecutar el programa paso a paso. |
| 📄 [`README_compilacion_latex.md`](documentacion/README_compilacion_latex.md) | Cómo regenerar el PDF del reporte a partir de `reporte.tex` usando TeX Live, Geany o VS Code, tanto en Linux como en Windows. |
| 📕 [`reporte.pdf`](documentacion/reporte.pdf) | Reporte técnico ya compilado, con análisis detallado de las tres rutinas y la metodología de medición. |
| 📝 [`reporte.tex`](documentacion/reporte.tex) | Fuente LaTeX del reporte técnico. |

---

> **Autor:** Edson Joel Carrera Avila
