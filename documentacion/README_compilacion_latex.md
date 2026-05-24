# 📄 Cómo generar un PDF desde un archivo `.tex`

Guía paso a paso para principiantes sobre cómo convertir un archivo de **LaTeX** (`.tex`) en un documento **PDF** utilizando las herramientas **TeX Live**, **Geany** y **Visual Studio Code (VS Code)**, tanto en **Linux** como en **Windows**.

---

## 📑 Índice

- [📚 ¿Qué es cada herramienta?](#-qué-es-cada-herramienta)
- [🔗 Enlaces de descarga](#-enlaces-de-descarga)
- [🐧 Instrucciones para Linux](#-instrucciones-para-linux)
  - [1️⃣ Instalar TeX Live](#1️⃣-instalar-tex-live)
  - [2️⃣ Instalar Geany (opción ligera)](#2️⃣-instalar-geany-opción-ligera)
  - [3️⃣ Instalar VS Code (opción moderna)](#3️⃣-instalar-vs-code-opción-moderna)
- [🪟 Instrucciones para Windows](#-instrucciones-para-windows)
  - [1️⃣ Instalar TeX Live](#1️⃣-instalar-tex-live-1)
  - [2️⃣ Instalar Geany (opción ligera)](#2️⃣-instalar-geany-opción-ligera-1)
  - [3️⃣ Instalar VS Code (opción moderna)](#3️⃣-instalar-vs-code-opción-moderna-1)
- [💡 Alternativas sin instalación](#-alternativas-sin-instalación)

---

## 📚 ¿Qué es cada herramienta?

Antes de empezar, conviene entender qué hace cada programa:

- **TeX Live**: Es el "motor" que lee tu archivo `.tex` y produce el PDF. Sin él, nada funciona. **Es el componente más importante.**
- **Geany**: Un editor de texto sencillo y ligero. Sirve para escribir el código `.tex` y compilarlo con un solo clic.
- **Visual Studio Code (VS Code)**: Un editor más moderno y potente. Con una extensión especial (LaTeX Workshop by James Yu) compila automáticamente el PDF cada vez que guardas el archivo.

> 💡 **Solo necesitas un editor** (Geany **o** VS Code), pero TeX Live es obligatorio en ambos casos.

---

## 🔗 Enlaces de descarga

| Herramienta | Linux | Windows |
|---|---|---|
| **TeX Live** | Se instala desde la terminal (ver abajo) | [https://tug.org/texlive/windows.html](https://tug.org/texlive/windows.html) |
| **Geany** | Se instala desde la terminal (ver abajo) | [https://www.geany.org/download/releases/](https://www.geany.org/download/releases/) |
| **VS Code** | [https://code.visualstudio.com/Download](https://code.visualstudio.com/Download) | [https://code.visualstudio.com/Download](https://code.visualstudio.com/Download) |

---

# 🐧 Instrucciones para Linux

## 1️⃣ Instalar TeX Live

Abre una **terminal** (`Ctrl + Alt + T` en la mayoría de distribuciones) y copia el siguiente comando según tu sistema:

**Ubuntu / Debian / Linux Mint:**

```bash
sudo apt update
sudo apt install texlive-full
```

> ⚠️ La instalación puede tardar varios minutos y ocupa +6 GB. Si no tienes mucho espacio, puedes instalar la versión básica reemplazando `texlive-full` por `texlive-latex-base`.

Para verificar que se instaló correctamente, escribe en la terminal:

```bash
pdflatex --version
```

Si aparece información sobre la versión, ¡todo está listo!

---

## 2️⃣ Instalar Geany (opción ligera)

En la terminal, ejecuta:

**Ubuntu / Debian / Linux Mint:**

```bash
sudo apt install geany
```
### Compilar un `.tex` con Geany

1. Abre Geany.
2. Pulsa `Archivo > Abrir` y selecciona tu archivo `.tex`.
3. En el menú superior, ve a `Construir > LaTeX -> PDF`. 
> ⚠️ Si no aparece la opción PDF directamente, primero compila a DVI y luego usa `Construir > LaTeX -> PDF`.
4. El archivo PDF se generará en la **misma carpeta** donde está tu archivo `.tex`.

> 💡 **Atajo rápido:** Pulsa `F8` para compilar y `F5` para ver el resultado.

---

## 3️⃣ Instalar VS Code (opción moderna)

### Opción A: Descargar el paquete oficial `.deb` (recomendado para principiantes)

1. Entra a [https://code.visualstudio.com/Download](https://code.visualstudio.com/Download).
2. Descarga el archivo **`.deb`** (para Ubuntu/Debian/Mint) o **`.rpm`** (para Fedora).
3. Abre la terminal en la carpeta donde se descargó (normalmente `Descargas`) y ejecuta:

```bash
cd ~/Descargas
sudo apt install ./code_*.deb
```

> 💡 El símbolo `*` permite que el comando funcione sin importar la versión exacta del archivo descargado.

### Opción B: Instalar mediante Snap

Si tu distribución soporta Snap (Ubuntu lo incluye por defecto), puedes ejecutar:

```bash
sudo snap install code --classic
```

> ⚠️ La opción `--classic` es **obligatoria**; sin ella la instalación fallará.

### Configurar VS Code para LaTeX

1. Abre VS Code.
2. Ve al panel de extensiones (icono de cuadritos a la izquierda o pulsa `Ctrl + Shift + X`).
3. Busca **LaTeX Workshop by James Yu** e instálala.
4. Abre tu archivo `.tex` con `Archivo > Abrir archivo`.
5. Guarda con `Ctrl + S` y el PDF se generará automáticamente.
6. Para verlo, haz clic derecho en el código y elige **"View LaTeX PDF"**, o pulsa el icono de lupa en la esquina superior derecha.

---

# 🪟 Instrucciones para Windows

## 1️⃣ Instalar TeX Live

1. Entra a [https://tug.org/texlive/windows.html](https://tug.org/texlive/windows.html).
2. Descarga el archivo **`install-tl-windows.exe`**.
3. Ejecuta el instalador como administrador (clic derecho > **"Ejecutar como administrador"**).
4. Acepta las opciones por defecto y pulsa **"Install"**.

> ⏳ La instalación puede tardar **entre 1 y 3 horas** según tu conexión a internet, porque descarga miles de paquetes. Déjalo trabajando con paciencia.

Para verificar la instalación, abre el **Símbolo del sistema** (escribe `cmd` en el menú Inicio) y ejecuta:

```cmd
pdflatex --version
```

Si aparece información de versión, está todo correcto.

---

## 2️⃣ Instalar Geany (opción ligera)

1. Entra a [https://www.geany.org/download/releases/](https://www.geany.org/download/releases/).
2. Descarga el instalador `.exe` para Windows.
3. Ejecútalo y sigue las instrucciones (siguiente, siguiente, finalizar).

### Compilar un `.tex` con Geany en Windows

1. Abre Geany.
2. Ve a `Archivo > Abrir` y selecciona tu archivo `.tex`.
3. En el menú superior, ve a `Construir > LaTeX -> PDF`. 
> ⚠️ Si no aparece la opción PDF directamente, primero compila a DVI y luego usa `Construir > LaTeX -> PDF`.
4. El PDF aparecerá en la misma carpeta del archivo `.tex`.

---

## 3️⃣ Instalar VS Code (opción moderna)

1. Descarga el instalador desde [https://code.visualstudio.com/Download](https://code.visualstudio.com/Download).
2. Ejecuta el `.exe` y sigue las instrucciones de instalación. 
> ⚠️ Durante la instalación tendrás que marcar la casilla **"Agregar a PATH"**, esto evitará errores al momento de usar VS Code.

### Configurar VS Code para LaTeX

1. Abre VS Code.
2. Pulsa `Ctrl + Shift + X` para abrir extensiones.
3. Busca **LaTeX Workshop by James Yu** y haz clic en **Install**.
4. Abre tu archivo `.tex` con `Archivo > Abrir archivo`.
5. Guarda con `Ctrl + S` y se compilará automáticamente.
6. Para ver el PDF, pulsa el icono de lupa arriba a la derecha o haz clic derecho > **"View LaTeX PDF"**.

---

# 💡 Alternativas sin instalación

Si no quieres (o no puedes) instalar programas en tu equipo, existen **editores en línea** que compilan tu archivo `.tex` directamente desde el navegador. En algunos solo necesitas copiar y pegar tu código `.tex` o crear una cuenta gratuita y empezar a escribir.

🔗 **Enlace:** [https://www.overleaf.com](https://www.overleaf.com)

🔗 **Enlace:** [https://papeeria.com](https://papeeria.com)

---

> **Autor:** Edson Joel Carrera Avila