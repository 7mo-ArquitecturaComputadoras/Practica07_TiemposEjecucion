# 🛠️ Instalación y Puesta en Marcha

Guía paso a paso para clonar, compilar y ejecutar la **Práctica 07 — Tiempos de Ejecución: Producto Punto en FPU, SSE y AVX** en un equipo nuevo. Esta práctica está escrita en **ensamblador x64 (MASM)** con una interfaz en **C++** y se compila con **Visual Studio** en **Windows**.

---

## 📑 Índice

- [📚 ¿Qué herramientas necesitas?](#-qué-herramientas-necesitas)
- [🔗 Enlaces de descarga](#-enlaces-de-descarga)
- [1️⃣ Instalar Git](#1️⃣-instalar-git)
- [2️⃣ Instalar Visual Studio con MASM](#2️⃣-instalar-visual-studio-con-masm)
- [3️⃣ Clonar el repositorio](#3️⃣-clonar-el-repositorio)
- [4️⃣ Abrir la solución en Visual Studio](#4️⃣-abrir-la-solución-en-visual-studio)
- [5️⃣ Habilitar MASM en el proyecto](#5️⃣-habilitar-masm-en-el-proyecto)
- [6️⃣ Compilar el proyecto](#6️⃣-compilar-el-proyecto)
- [7️⃣ Ejecutar y observar el resultado](#7️⃣-ejecutar-y-observar-el-resultado)
- [❗ Problemas comunes](#-problemas-comunes)

---

## 📚 ¿Qué herramientas necesitas?

Antes de empezar, conviene entender qué hace cada programa:

- **Git**: Sistema de control de versiones. Sirve para descargar (clonar) el repositorio a tu computadora.
- **Visual Studio**: Entorno integrado de desarrollo (IDE) de Microsoft. Incluye el compilador, el linker y, lo más importante para esta práctica, **MASM** (`ml64.exe`), el ensamblador de 64 bits que traduce `tiempo.asm` a un ejecutable.
- **MASM** (*Microsoft Macro Assembler*): No se instala por separado, viene incluido dentro de la carga de trabajo *Desktop development with C++* de Visual Studio.

> 💡 No se requiere ningún compilador externo ni librerías adicionales. Todo lo que necesitas está dentro de Visual Studio.

> ⚠️ Tu procesador debe soportar **AVX** (Intel Sandy Bridge o más reciente / AMD Bulldozer o más reciente, todos posteriores a 2011). Casi cualquier equipo de la última década lo cumple.

---

## 🔗 Enlaces de descarga

| Herramienta | Windows |
|---|---|
| **Git** | [https://git-scm.com/download/win](https://git-scm.com/download/win) |
| **Visual Studio Community** (gratuito) | [https://visualstudio.microsoft.com/es/downloads/](https://visualstudio.microsoft.com/es/downloads/) |

> ⚠️ Esta práctica solo se compila en **Windows**, porque el código usa la convención de llamadas Microsoft x64 con MASM y los intrínsecos `<intrin.h>` de MSVC (`__rdtsc`, `_mm_lfence`). No funciona nativamente en Linux ni macOS.

---

## 1️⃣ Instalar Git

1. Entra a [https://git-scm.com/download/win](https://git-scm.com/download/win).
2. Descarga el instalador `.exe` (la descarga inicia automáticamente).
3. Ejecuta el instalador y acepta las opciones por defecto pulsando **"Next"** en cada pantalla.

Para verificar la instalación, abre el **Símbolo del sistema** (escribe `cmd` en el menú Inicio) y ejecuta:

```cmd
git --version
```

Si aparece un número de versión, todo está listo.

---

## 2️⃣ Instalar Visual Studio con MASM

1. Entra a [https://visualstudio.microsoft.com/es/downloads/](https://visualstudio.microsoft.com/es/downloads/).
2. Descarga **Visual Studio Community** (la versión gratuita).
3. Ejecuta el instalador. Aparecerá una ventana llamada **"Visual Studio Installer"**.
4. En la pestaña **"Cargas de trabajo"** (*Workloads*), marca la casilla:

   ✅ **Desarrollo para el escritorio con C++** (*Desktop development with C++*)

   > 🔑 Esta casilla es **obligatoria**: dentro de ella viene MASM x64 (`ml64.exe`), el ensamblador que compila el archivo `.asm`. Sin esta carga de trabajo, el proyecto **no compilará**.

5. Haz clic en **"Instalar"** y espera. La descarga e instalación puede tardar entre 30 minutos y 2 horas según tu conexión.

> ⏳ Visual Studio ocupa entre 8 y 15 GB de espacio en disco con esta carga de trabajo.

---

## 3️⃣ Clonar el repositorio

Abre el **Símbolo del sistema** (`cmd`) o **Git Bash**, ubícate en la carpeta donde quieras guardar el proyecto y ejecuta:

```bash
git clone git@github.com:7mo-ArquitecturaComputadoras/Practica07_TiemposEjecucion.git
```

---

## 4️⃣ Abrir la solución en Visual Studio

1. Entra a la carpeta `proyecto/` dentro del repositorio.
2. Haz doble clic sobre **`Practica07_TiemposEjecucion.slnx`**.
3. Visual Studio se abrirá y cargará automáticamente el proyecto, incluidos los archivos `src/tiempo.asm` y `src/main.cpp`.

> 💡 El archivo `.slnx` es la versión moderna de los `.sln` clásicos. Si tu versión de Visual Studio no lo reconoce, abre directamente el `.vcxproj`.

---

## 5️⃣ Habilitar MASM en el proyecto

La primera vez que abras la solución, es posible que Visual Studio no reconozca las directivas `PROC`, `.code`, etc. Para activar MASM:

1. En el **Explorador de soluciones** (panel derecho), haz clic derecho sobre el proyecto **Practica07_TiemposEjecucion**.
2. Selecciona **"Generar dependencias"** → **"Personalizaciones de compilación…"** (*Build Customizations…*).
3. En la lista que aparece, marca la casilla:

   ✅ **masm(.targets, .props)**

4. Pulsa **"Aceptar"**.

> ⚠️ Si esta casilla **no aparece** en la lista, significa que MASM no se instaló. Vuelve al paso 2️⃣ y verifica que marcaste la carga de trabajo *Desarrollo para el escritorio con C++*.

---

## 6️⃣ Compilar el proyecto

1. En la barra superior, selecciona la configuración **Release** y la plataforma **x64**.

   > 🔑 Es **obligatorio** usar **x64**, porque las rutinas en `tiempo.asm` están escritas con la convención de llamadas Microsoft x64 (`RCX`, `RDX`, `R8`, `XMM0`) y usan registros `YMM` de 256 bits que no existen en modo de 32 bits.

   > 🔑 Se recomienda **Release** sobre **Debug**: en modo Debug el compilador inserta verificaciones de seguridad que añaden cientos de ciclos a cada llamada y oscurecen la comparación entre FPU, SSE y AVX.

2. Pulsa `Ctrl + Shift + B` o ve al menú **Compilar** → **Compilar solución**.
3. En la ventana de salida (parte inferior) debe aparecer:

   ```
   ========== Compilación: 1 correctos, 0 incorrectos ==========
   ```

El ejecutable se generará en `proyecto/x64/Release/Practica07_TiemposEjecucion.exe`.

> 💡 Las carpetas `Debug/` y `x64/` están incluidas en el `.gitignore` y no se suben al repositorio: cada quien las genera localmente al compilar.

---

## 7️⃣ Ejecutar y observar el resultado

El programa inicializa dos vectores de 1000 elementos `float` y mide el tiempo en ciclos de cada rutina (FPU, SSE, AVX).

1. Pulsa `Ctrl + F5` para ejecutar sin depuración.
2. Observa la consola: se imprimen tres líneas, una por cada rutina, con el resultado y los ciclos consumidos.

### Ejemplo de ejecución

```
Calculando Producto Punto (N = 1000)
--------------------------------------------------
FPU | Res: 3000.0 | Tiempo: 3200 ciclos
SSE | Res: 3000.0 | Tiempo:  650 ciclos
AVX | Res: 3000.0 | Tiempo:  340 ciclos
--------------------------------------------------
```

Los **ciclos exactos** dependen de tu procesador, su carga, la temperatura y el estado de la caché. Lo importante es que la jerarquía `FPU > SSE > AVX` se mantenga y que las tres rutinas devuelvan `3000.0`.

> 💡 Ejecuta el programa varias veces seguidas. Los ciclos pueden variar entre ejecuciones por interrupciones del sistema operativo. Para un estudio serio se promedian al menos 5 mediciones por rutina.

### Inspección de los registros YMM con el depurador

Para ver el contenido de los registros AVX durante la ejecución:

1. Abre `proyecto/src/tiempo.asm` en el editor.
2. Coloca un *breakpoint* en la línea `vaddps ymm0, ymm0, ymm1` dentro de `productoPunto_avx`.
3. Pulsa `F5` para iniciar la depuración (en Debug | x64).
4. Cuando se detenga, ve a **Depurar** → **Ventanas** → **Registros**.
5. Haz clic derecho en la ventana de Registros y activa el grupo **AVX** (muestra `YMM0..YMM15`).
6. Pulsa `F10` varias veces para observar cómo `YMM0` acumula los productos en sus 8 carriles.

---

## ❗ Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `error LNK2019: unresolved external symbol productoPunto_fpu` | Las funciones del `.asm` no se exportan o `extern "C"` no coincide | Verifica que `tiempo.asm` declare las tres rutinas con `PUBLIC` y que `main.cpp` las declare con `extern "C"` |
| `error MSB6006: "ml64.exe" exited with code 1` | Ruta del archivo `.asm` rota o sintaxis incorrecta | Verifica que `proyecto/src/tiempo.asm` exista y que el `.vcxproj` lo incluya como elemento `<MASM>` |
| `error C2065: '__rdtsc': identifier not found` | Falta el `#include <intrin.h>` o el compilador no soporta intrínsecos | Verifica que `main.cpp` incluya `<intrin.h>` y que el conjunto de herramientas sea MSVC (no MinGW) |
| `error: instruction not supported on this CPU` al ejecutar | El procesador no soporta AVX | Verifica que tu procesador sea posterior a 2011; en CPU-Z confirma el flag **AVX** en la pestaña *Instructions* |
| **masm(.targets, .props)** no aparece en *Personalizaciones de compilación* | Falta la carga de trabajo *Desarrollo C++* | Abre **Visual Studio Installer**, pulsa **"Modificar"** y agrégala |
| Los ciclos son enormes (decenas de miles) | Configuración en **Debug** en lugar de **Release** | Cambia a **Release | x64** en la barra superior |
| Los ciclos de SSE/AVX son mayores que los de FPU | Compilando en **Win32** en lugar de **x64**, o sin `/arch:AVX` | Verifica que la plataforma sea **x64** y la configuración **Release** |
| `git` no se reconoce como comando | Git no se instaló o no se agregó al PATH | Reinstala Git marcando *"Git from the command line and also from 3rd-party software"* |
| El `.slnx` no abre | Versión de Visual Studio anterior a 2022 17.10 | Abre directamente `Practica07_TiemposEjecucion.vcxproj` |
| Crash al hacer `movaps`/`vmovaps` | Vectores no alineados a 16/32 bytes | Verifica que `main.cpp` use `alignas(32)` al declarar `A` y `B` |

---

> **Autor:** Edson Joel Carrera Avila
