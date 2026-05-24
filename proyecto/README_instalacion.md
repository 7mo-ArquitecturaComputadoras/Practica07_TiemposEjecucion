# 🛠️ Instalación y Puesta en Marcha

Guía paso a paso para clonar, compilar y ejecutar la **Práctica 04 — Conversión de Decimal a Binario** en un equipo nuevo. Esta práctica está escrita en **ensamblador x86 (MASM)** con una interfaz en **C++** y se compila con **Visual Studio** en **Windows**.

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
- **Visual Studio**: Entorno integrado de desarrollo (IDE) de Microsoft. Incluye el compilador, el linker y **MASM** (`ml.exe`), el ensamblador que traduce `conversion.asm` a un ejecutable.
- **MASM** (*Microsoft Macro Assembler*): No se instala por separado, viene incluido en la carga de trabajo *Desktop development with C++* de Visual Studio.

---

## 🔗 Enlaces de descarga

| Herramienta | Windows |
|---|---|
| **Git** | [https://git-scm.com/download/win](https://git-scm.com/download/win) |
| **Visual Studio Community** | [https://visualstudio.microsoft.com/es/downloads/](https://visualstudio.microsoft.com/es/downloads/) |

---

## 1️⃣ Instalar Git

1. Entra a [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. Descarga el instalador `.exe`
3. Ejecuta y acepta las opciones por defecto

Verifica: `git --version` en cmd

---

## 2️⃣ Instalar Visual Studio con MASM

1. Entra a [https://visualstudio.microsoft.com/es/downloads/](https://visualstudio.microsoft.com/es/downloads/)
2. Descarga **Visual Studio Community**
3. En el instalador, marca: ✅ **Desarrollo para el escritorio con C++**
4. Instala (30 minutos a 2 horas)

---

## 3️⃣ Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd Practica04_ConversionDecimalBinario
```

---

## 4️⃣ Abrir la solución en Visual Studio

1. Entra a la carpeta `proyecto/`
2. Haz doble clic en **`Practica04_ConversionDecimalBinario.slnx`**
3. Visual Studio abre el proyecto

---

## 5️⃣ Habilitar MASM en el proyecto

1. Clic derecho en el proyecto (Explorador de soluciones)
2. **"Generar dependencias"** → **"Personalizaciones de compilación…"**
3. Marca: ✅ **masm(.targets, .props)**
4. **"Aceptar"**

---

## 6️⃣ Compilar el proyecto

1. Selecciona **Debug | Win32** (32 bits, OBLIGATORIO)
2. `Ctrl + Shift + B` o **Compilar → Compilar solución**
3. Debe aparecer: `========== Compilación: 1 correctos, 0 incorrectos ==========`

---

## 7️⃣ Ejecutar y observar el resultado

El programa solicita un **número decimal** e imprime su **binario**:

```bash
Ingrese un número decimal: 42
Número en binario: 101010
```

Pulsa `Ctrl + F5` para ejecutar

---

## ❗ Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `error A2006: undefined symbol : ExitProcess` | Configuración en **x64** con código de 32 bits | Cambia la plataforma a **Win32** en la barra superior |
| `error MSB6006: "ml.exe" exited with code 1` | Ruta del archivo `.asm` rota | Verifica que `proyecto/src/conversion.asm` exista |
| **masm(.targets, .props)** no aparece en *Personalizaciones de compilación* | Falta la carga de trabajo *Desarrollo C++* | Abre **Visual Studio Installer**, pulsa **"Modificar"** y agrégala |
| `git` no se reconoce como comando | Git no se instaló o no se agregó al PATH | Reinstala Git marcando *"Git from the command line and also from 3rd-party software"* |
| El `.slnx` no abre | Versión de Visual Studio anterior a 2022 17.10 | Abre directamente `Practica04_ConversionDecimalBinario.vcxproj` |
| Errores de compilación en `main.cpp` | Archivos de encabezado de C++ faltantes | Verifica que la carga de trabajo *Desarrollo C++* esté completamente instalada |

---

> **Autor:** Edson Joel Carrera Avila
