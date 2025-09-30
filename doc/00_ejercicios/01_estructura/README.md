##  Enunciados
Una biblioteca en línea desea implementar un sistema que permita a sus usuarios acceder a los servicios de manera digital. El sistema debe contemplar, al menos, las siguientes funcionalidades:

Registro y gestión de usuarios: creación y actualización de cuentas personales.

Catálogo de ejemplares: consulta de libros disponibles, con información básica como título, autor, año de publicación y disponibilidad.

Gestión de préstamos: solicitud de préstamos por parte de usuarios registrados, control de fechas de devolución.

Notificaciones automáticas: envío de recordatorios de vencimiento de préstamos.

Gestión administrativa: incorporación y mantenimiento de ejemplares por parte del personal bibliotecario.

A partir de esta descripción, cada alumno o grupo de trabajo deberá proponer una organización inicial del modelo, respondiendo a las siguientes cuestiones:

¿Qué vistas (negocio, lógica, datos, física) serían necesarias para representar de forma adecuada el sistema?

¿Cómo se deberían estructurar los paquetes y subpaquetes del modelo para facilitar su comprensión y mantenimiento?

¿Qué nivel de abstracción corresponde a cada fase del proyecto (conceptual, lógico, físico) y qué elementos incluiría cada nivel?

El objetivo es que los alumnos aprendan a estructurar un modelo con criterio y coherencia, diferenciando vistas, paquetes y niveles de abstracción.

## Respuesta: Unidad 01 - Ejercicio guiado — Propuesta de solución
**Caso:** Biblioteca en línea  
**Objetivo:** Proponer una organización inicial del modelo diferenciando **vistas**, **paquetes** y **niveles de abstracción**.

---

## 0. Supuestos y alcance
- El servicio es **multicanal** (web responsive y API interna para app futura).
- Un usuario puede realizar **múltiples préstamos** y cada préstamo está **limitado en el tiempo**.
- Las notificaciones se envían por **correo electrónico** (y se deja preparado para SMS en el futuro).
- Se admite **catálogo público** (consulta sin autenticación) y **operaciones privadas** (requieren inicio de sesión).
- El personal bibliotecario gestiona **altas/actualizaciones** de ejemplares y **devoluciones**.

> *No se incluyen pasarelas de pago ni funcionalidades de reservas de salas, para mantener el foco del modelo.*

---

## 1. Vistas del sistema

### 1.1 Vista de Negocio
- **Actores:** Visitante, Usuario registrado, Bibliotecario, Sistema de Correo.
- **Procesos clave (BPMN/diagramas de actividad):**
    - Consultar catálogo
    - Registro de usuario
    - Solicitar préstamo
    - Devolver ejemplar
    - Administrar catálogo
    - Enviar recordatorio de vencimiento
- **Requisitos (ejemplos):**
    - RQ-01: El sistema permitirá registrar usuarios con validación de correo.
    - RQ-02: El catálogo será consultable sin autenticación.
    - RQ-03: El sistema notificará vencimientos con 3 días de antelación.

### 1.2 Vista Lógica (Arquitectura de solución)
- **Módulos/Componentes:**
    - Autenticación y cuentas
    - Gestión de usuarios
    - Catálogo y búsqueda
    - Préstamos y devoluciones
    - Notificaciones
    - Administración (backoffice)
    - Integración (correo)
- **Interfaces:**
    - `CatalogAPI`, `LoansAPI`, `NotificationsService`
- **Reglas de negocio (ejemplos):**
    - Un usuario no puede tener más de *N* préstamos activos.
    - Un ejemplar no puede asignarse a dos préstamos simultáneamente.

### 1.3 Vista de Datos
- **Entidades principales (ER/UML clases):**
    - `Usuario(id, nombre, email, estado, fechaAlta)`
    - `Libro(id, titulo, autor, anio, isbn)`
    - `Ejemplar(id, idLibro, codigoInventario, estado)`
    - `Prestamo(id, idUsuario, idEjemplar, fechaInicio, fechaVencimiento, fechaDevolucion)`
    - `Notificacion(id, idUsuario, tipo, fechaProgramada, estado)`
- **Relaciones:**
    - `Libro (1) —— (N) Ejemplar`
    - `Usuario (1) —— (N) Prestamo`
    - `Ejemplar (1) —— (0..N) Prestamo` (secuencial en el tiempo)

### 1.4 Vista Física (Despliegue)
- **Nodos principales:**
    - `WebApp Server` (servicio web y APIs)
    - `DB Server` (RDBMS)
    - `Mail Gateway` (servicio SMTP)
    - `Reverse Proxy / Load Balancer` (opcional para escalado)
- **Conectividad y puertos:** HTTPS entre cliente y `WebApp`, conexión segura `WebApp` ↔ `DB`, `WebApp` ↔ `Mail Gateway`.

---

## 2. Estructura propuesta de paquetes

biblioteca-online/
├─ 00-negocio/
│ ├─ actores/
│ ├─ procesos/
│ └─ requisitos/
├─ 10-logico/
│ ├─ autenticacion-y-cuentas/
│ ├─ usuarios/
│ ├─ catalogo-y-busqueda/
│ ├─ prestamos-y-devoluciones/
│ ├─ notificaciones/
│ ├─ administracion/
│ └─ integracion/
├─ 20-datos/
│ ├─ modelo-conceptual/
│ ├─ modelo-logico/
│ └─ modelo-fisico/
├─ 30-fisico/
│ ├─ nodos/
│ └─ topologias/
├─ 40-transversales/
│ ├─ reglas-de-negocio/
│ ├─ seguridad-y-permisos/
│ └─ trazabilidad/
└─ 90-documentacion/
├─ decisiones-arquitectonicas/
└─ plantillas/


**Criterios:**
- Numeración prefijada para **ordenar vistas**.
- Paquetes por **módulo funcional** dentro de la vista lógica.
- Separación de **modelo conceptual/logico/físico** de datos.
- Paquete transversal para **seguridad**, **reglas** y **trazabilidad**.

---

## 3. Niveles de abstracción y artefactos

### 3.1 Nivel Conceptual (¿Qué? — independencia tecnológica)
- **Artefactos:**
    - Actores y procesos de negocio (BPMN/actividades).
    - Catálogo de requisitos (funcionales/no funcionales).
    - Modelo de datos **conceptual** (entidades y relaciones de alto nivel).
    - Reglas de negocio expresadas en lenguaje natural controlado.
- **Ejemplo:** Entidad `Libro` sin decidir motor de base de datos ni tipos concretos.

### 3.2 Nivel Lógico (¿Cómo? — diseño de solución)
- **Artefactos:**
    - Diagrama de componentes y servicios.
    - Interfaces y contratos (API sketch/IDL).
    - Modelo de datos **lógico** (normalización, claves candidatas).
    - Casos de uso/diagramas de secuencia clave (p. ej. “Solicitar préstamo”).
    - Políticas de seguridad (roles, permisos).
- **Ejemplo:** `LoansAPI` define operaciones `crearPrestamo()`, `cerrarPrestamo()` y precondiciones.

### 3.3 Nivel Físico (¿Con qué? — implementación y despliegue)
- **Artefactos:**
    - Modelo de datos **físico** (DDL, tipos concretos, índices).
    - Diagrama de **despliegue** (nodos, puertos, endpoints).
    - Parámetros de configuración (SMTP host, TTL notificaciones).
    - Scripts de automatización/infra como código (si aplica).
- **Ejemplo:** Tabla `prestamos` con índices en `(id_usuario, fechaVencimiento)` para acelerar avisos.

---

## 4. Ejemplo de trazabilidad (muestra)

| Requisito | Artefacto (Negocio)       | Artefacto (Lógico)        | Artefacto (Datos)     | Artefacto (Físico)         |
|-----------|----------------------------|---------------------------|-----------------------|----------------------------|
| RQ-02     | Proceso: Consultar catálogo| `CatalogAPI.listarLibros` | Entidad `Libro`       | Índice `libro.titulo`      |
| RQ-03     | Proceso: Enviar recordatorio| `NotificationsService`    | `Notificacion`        | Cron job / cola mensajes   |

> **Beneficio:** el impacto de un cambio en un requisito se puede seguir hasta APIs, tablas e infraestructura.

---

## 5. Consideraciones de seguridad y calidad (transversal)
- **Seguridad:** cifrado de credenciales, roles `usuario`/`bibliotecario`, control de acceso a préstamos.
- **Calidad de datos:** unicidad de `isbn`, integridad referencial `Ejemplar → Libro`.
- **Disponibilidad:** colas/reintentos para envío de notificaciones; registros de fallos.
- **Escalabilidad:** separar `CatalogAPI` (lecturas intensivas) de `LoansAPI` (transaccional).

---

## 6. Mini-caso ilustrativo: flujo “Solicitar préstamo” (resumen)
1. Usuario autenticado selecciona un **ejemplar disponible**.
2. `LoansAPI` valida reglas (límite de préstamos activos, disponibilidad).
3. Se crea **Prestamo** con `fechaVencimiento = fechaInicio + políticaBiblioteca`.
4. Se programa **Notificacion** a `fechaVencimiento - 3 días`.
5. Se actualiza estado del **Ejemplar** a “prestado”.
6. Se confirma al usuario.

**Artefactos implicados por vista:**
- Negocio: Proceso “Solicitar préstamo”.
- Lógica: Componentes `Autenticación`, `Préstamos`, `Notificaciones`.
- Datos: `Usuario`, `Ejemplar`, `Prestamo`, `Notificacion`.
- Física: `WebApp Server` ↔ `DB Server` ↔ `Mail Gateway`.

---

## 7. Resultado esperado
Con esta organización, el modelo es **navegable**, **mantenible** y **trazable**:
- Las **vistas** separan preocupaciones (negocio, solución, datos, despliegue).
- Los **paquetes** encapsulan responsabilidades y permiten trabajo en paralelo.
- Los **niveles de abstracción** alinean el avance desde el *qué* hasta el *con qué*.
