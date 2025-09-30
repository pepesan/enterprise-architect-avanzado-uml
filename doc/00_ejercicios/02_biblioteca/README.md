# Ejercicios de la Unidad 02: Diagramas UM

## Ejercicio 01 - Ejercicio guiado
**Caso:** Biblioteca en línea
**Objetivo:** Proponer un diagrama de clases UML que represente las entidades y relaciones clave del sistema.
**Alcance:** Incluir las entidades principales relacionadas con usuarios, libros, ejemplares, préstamos y notificaciones.
**Supuestos:**
- Un usuario puede tener múltiples préstamos.
- Cada libro puede tener múltiples ejemplares.
- Un préstamo está asociado a un único ejemplar.
- Las notificaciones están vinculadas a usuarios y pueden ser de diferentes tipos (recordatorio de vencimiento, confirmación de préstamo, etc.).
- El sistema debe permitir la gestión de usuarios y ejemplares por parte del personal bibliotecario.
- El sistema debe registrar la fecha de alta de usuarios y la fecha de creación de ejemplares.
- El sistema debe manejar el estado de los ejemplares (disponible, prestado, reservado, etc.).
- El sistema debe registrar la fecha de inicio y vencimiento de los préstamos, así como la fecha de devolución.
- El sistema debe permitir la gestión de notificaciones, incluyendo el tipo de notificación y su estado (pendiente, enviada, fallida).

**Entidades y relaciones clave:**
- **Usuario**
- **Libro**
- **Ejemplar**
- **Préstamo**
- **Notificación**