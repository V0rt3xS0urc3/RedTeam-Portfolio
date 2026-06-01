#  Guía de Contribución

Gracias por tu interés en **Kali Portable Full**. Todas las contribuciones son bienvenidas, ya sea código, documentación, reportes de errores o mejoras de seguridad.

Para mantener un estándar de calidad y seguridad, por favor sigue estas directrices antes de enviar un Pull Request.

---

## ️ Cómo Contribuir

### 1. Reportar Bugs o Solicitar Features
- Usa la sección [Issues](../../issues) de GitHub.
- Incluye:
  - Versión de Docker y sistema operativo host.
  - Pasos para reproducir el problema.
  - Capturas de pantalla o logs relevantes.
  - Comportamiento esperado vs. comportamiento actual.

### 2. Contribuir con Código o Documentación
1. **Fork** este repositorio.
2. Crea una rama descriptiva:
   ```bash
   git checkout -b fix/error-hashcat-gpu
   git checkout -b feat/soporte-amd-rocm
   git checkout -b docs/mejora-instalacion-wsl

3. Realiza tus cambios y verifica que el contenedor se construye correctamente:
cd docker
docker build -t kali-pentest-test .
docker run --rm -it kali-pentest-test bash

4. Asegúrate de que los scripts principales siguen siendo ejecutables:
chmod +x ../scripts/*.sh

5. Haz commit siguiendo el formato:
git commit -m "fix: corregir detección de GPU en contenedores WSL2"
git commit -m "feat: agregar soporte para reglas Hashcat personalizadas"
git commit -m "docs: actualizar instrucciones de instalación en macOS"

6. Sube tu rama y abre un Pull Request contra main.

Estándares de Código y Docker

    Dockerfile:
        Usa siempre --no-install-recommends en apt install para mantener la imagen ligera.
        Limpia cachés al final de cada RUN: && apt clean && rm -rf /var/lib/apt/lists/*
        Prefiere capas múltiples y aprovecha el caché de Docker.
    Scripts Bash:
        Usa #!/bin/bash y set -euo pipefail al inicio.
        Comenta secciones críticas y usa colores solo para salida de usuario, nunca en logs.
        Valida siempre la existencia de archivos y directorios antes de operar sobre ellos.
    Seguridad:
        Nunca hardcodees credenciales, tokens o claves en el código o Dockerfile.
        Usa variables de entorno o montajes de volumen para datos sensibles.

🧪 Pruebas Obligatorias
Antes de enviar un PR, verifica:

    docker build termina sin errores.
    ./run-kali.sh normal inicia y muestra el banner correctamente.
    Los volúmenes persistentes se montan en data/ sin errores de permisos.
    hashcat -I detecta la GPU si el host tiene drivers NVIDIA + Container Toolkit.
    Los scripts auto-crack-wpa2.sh y setup-wifi.sh muestran ayuda y validan argumentos.

Licencia y Atribución
Al contribuir, aceptas que tu código se distribuya bajo la licencia MIT del proyecto. Si agregas herramientas o recursos de terceros, indica claramente su origen y licencia en el PR.

📬 Contacto
¿Dudas antes de contribuir? Abre un Issue de tipo Question
 o contacta directamente al mantenedor:
LinkedIn: diegoarriagadazamora
GitHub: Vort3xS0urc3

Gracias por ayudar a mantener este proyecto profesional, seguro y útil para la comunidad. 🔐
