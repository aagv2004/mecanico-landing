# Explicación Técnica del Proyecto - MECÁNICO DE CONFIANZA

Este documento detalla paso a paso las decisiones técnicas, la estructura del proyecto y las herramientas implementadas durante el proceso de modernización "DevOps & Modern Web".

## 1. Estructura del Proyecto

### ¿Por qué cambiamos la estructura?

Antes teníamos todo en un solo archivo. Esto funciona para demos, pero es inmanejable profesionales. Hemos adoptado una estructura modular estándar en la industria.

### Mapa de Archivos

- **`/src`**: Aquí vive el código fuente "crudo".
  - **`main.js`**: El cerebro de la aplicación. Importa los estilos e inicia la lógica.
  - **`style.css`**: Estilos globales. Ya no están "inline" en el HTML, lo que permite que el navegador los guarde en caché.
- **`index.html`**: Ahora vive en la raíz, pero es "dueño" de Vite. Note que el script se incluye como `type="module"`, lo que activa características modernas de JavaScript.
- **`vite.config.js`**: El centro de control de nuestra herramienta de construcción.
- **`.github/workflows`**: Las instrucciones para los robots de GitHub (CI/CD).

## 2. Herramientas Implementadas

### Vite (El Constructor)

En lugar de simplemente abrir el HTML, usamos Vite.

- **Rol**: Servidor de desarrollo y empaquetador para producción.
- **Beneficio**: Recarga instantánea (HMR) y optimización de archivos (minificación) automática al subir a producción.

## 6. Estilos (Tailwind CSS v3)

Hemos adoptado **Tailwind CSS (versión 3)**.

- **Por qué v3**: Elegimos específicamente la versión 3 (y no la 4) para asegurar máxima compatibilidad con el ecosistema actual de herramientas y evitar problemas de configuración inicial.
- **Configuración**: `tailwind.config.js` escanea `index.html` y todos los archivos en `src/` para generar solo el CSS que usamos.

## 7. Nuevas Secciones (Servicios)

Hemos agregado una sección de **Servicios** en `index.html` para demostrar el poder de Tailwind:

- **Grid System**: Usamos `grid grid-cols-1 md:grid-cols-3` para crear un diseño que es de 1 columna en móviles y 3 en PC automáticamente.
- **Tarjetas (Cards)**: Usamos utilidades de sombreado (`shadow-md`, `hover:shadow-lg`) para dar profundidad y feedback visual al pasar el mouse.

### ESLint (El Inspector)

- **Rol**: Analiza el código buscando errores antes de que sucedan.
- **Reglas**: Hemos configurado reglas estándar para evitar variables no usadas o errores de sintaxis comunes.

### Prettier (El Estilista)

- **Rol**: Formatea el código automáticamente.
- **Beneficio**: No importa quién escriba el código, siempre se verá igual.

## 3. Configuración de Archivos (`.rc` y `config.js`)

### `vite.config.js`

Le dice a Vite que use el puerto 3000 y que al construir ("build") guarde todo en la carpeta `dist`.

### `eslint.config.js`

Define que usaremos JavaScript moderno (ECMAScript 2022) y el ambiente de navegador y Node.js.

### `.prettierrc`

Nuestras reglas de estilo: comillas simples, punto y coma al final, y sangría de 2 espacios.

---

## 4. Automatización (CI/CD)

Hemos actualizado `.github/workflows/calidad.yaml`.

- **Antes**: Solo revisaba el HTML con una herramienta básica.
- **Ahora**:
  1. Instala dependencias (`npm ci`).
  2. Revisa la calidad del código (`npm run lint`).
  3. Intenta construir el proyecto (`npm run build`).
     Si cualquiera de estos pasos falla, GitHub nos avisará y bloqueará la fusión del código erróneo.

## 5. Docker (Despliegue Universal)

El `Dockerfile` usa una estrategia "Multi-stage" (multietapa):

1.  **Fase Builder**: Usa una imagen pesada con Node.js para compilar el proyecto.
2.  **Fase Runner**: Toma _solo_ lo que generó la fase anterior y lo pone en un servidor web ultra-ligero (Nginx).
    **Resultado**: Una imagen final muy pequeña y segura.
