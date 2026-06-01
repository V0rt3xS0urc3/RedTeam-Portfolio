
---

## 🛡️ `SECURITY.md`

```markdown
# 🛡️ Política de Seguridad

La seguridad es fundamental en **Kali Portable Full**. Dado que esta herramienta está diseñada para auditorías de seguridad autorizadas, seguimos un proceso estricto de divulgación responsable.

---

## 📦 Versiones Soportadas

| Versión | Soporte de Seguridad |
|---------|----------------------|
| `latest` (main) | ✅ Activo |
| Versiones anteriores |  No mantenidas |

Te recomendamos ejecutar siempre la última versión estable disponible en [Releases](../../releases).

---

## 📩 Reportar una Vulnerabilidad

Si encuentras una vulnerabilidad de seguridad en el Dockerfile, scripts, dependencias o configuración, **no la publiques en Issues públicos**.

### Pasos para reportar:
1. Envía un correo a: `security@tu-dominio.com` *(reemplaza con tu correo real o usa GitHub Private Vulnerability Reporting)*
2. Incluye en el asunto: `[SECURITY] Breve descripción del problema`
3. En el cuerpo, detalla:
   - Componente afectado (Dockerfile, script, dependencia, etc.)
   - Pasos para reproducir
   - Impacto potencial
   - Parche o mitigación sugerida (opcional pero apreciado)
4. Usa PGP si deseas cifrar el reporte (clave pública disponible bajo petición).

### Qué NO reportar aquí:
- Problemas de uso indebido o configuración incorrecta del host.
- Vulnerabilidades en herramientas de terceros ya empaquetadas (reportalas directamente a sus mantenedores).
- Solicitudes de soporte técnico general (usa [Issues](../../issues)).

---

## ⏱️ Qué Esperar Después de Reportar

| Etapa | Tiempo Estimado |
|-------|-----------------|
| Acuse de recibo | 24-48 horas |
| Evaluación técnica | 3-5 días hábiles |
| Parche o mitigación | 7-14 días (dependiendo de complejidad) |
| Publicación de fix | Inmediata tras validación |

Mantenemos comunicación constante durante el proceso. Si el reporte es válido, se acreditará tu nombre en el changelog de seguridad (a menos que prefieras anonimato).

---

## 🔒 Buenas Prácticas para Usuarios

- 🔐 Ejecuta siempre el contenedor con usuarios no root en el host cuando sea posible.
-  No expongas puertos del contenedor a redes no confiables sin firewalls.
- 🔄 Actualiza la imagen regularmente: `docker pull kali-pentest-full`
- 📜 Usa este toolkit únicamente en entornos autorizados y conforme a leyes locales.

---

## ️ Aviso Legal

Este proyecto es una herramienta de auditoría de seguridad. El mantenedor no se hace responsable por vulnerabilidades derivadas del uso indebido, configuración insegura del host o dependencia desactualizada por parte del usuario. Se espera que los usuarios mantengan sus sistemas base actualizados y sigan prácticas de hardening estándar.

---

*Gracias por ayudar a mantener Kali Portable Full seguro y confiable.* 🔐
