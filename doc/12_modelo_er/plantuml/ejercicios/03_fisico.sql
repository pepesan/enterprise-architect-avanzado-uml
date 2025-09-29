-- Dominio / enums (opcional, más legible)
CREATE TYPE rol_usuario AS ENUM ('ALUMNO', 'PROFESOR');
CREATE TYPE estado_matricula AS ENUM ('ACTIVA', 'PENDIENTE', 'BAJA');
CREATE TYPE metodo_pago AS ENUM ('TARJETA', 'TRANSFERENCIA', 'PAYPAL');

-- 1) USUARIO
CREATE TABLE usuario (
                         id_usuario UUID PRIMARY KEY,
                         nombre     VARCHAR(120) NOT NULL,
                         email      VARCHAR(150) NOT NULL UNIQUE,
                         rol        rol_usuario  NOT NULL DEFAULT 'ALUMNO'
);

-- 2) CURSO
CREATE TABLE curso (
                       id_curso    UUID PRIMARY KEY,
                       titulo      VARCHAR(200) NOT NULL,
                       descripcion TEXT
);

-- 3) MATRICULA (Usuario x Curso)
CREATE TABLE matricula (
                           id_matricula UUID PRIMARY KEY,
                           fecha_alta   TIMESTAMP NOT NULL DEFAULT NOW(),
                           estado       estado_matricula NOT NULL DEFAULT 'PENDIENTE',
                           id_usuario   UUID NOT NULL REFERENCES usuario(id_usuario),
                           id_curso     UUID NOT NULL REFERENCES curso(id_curso),
                           CONSTRAINT uq_matricula UNIQUE (id_usuario, id_curso)
);

CREATE INDEX ix_matricula_usuario ON matricula(id_usuario);
CREATE INDEX ix_matricula_curso   ON matricula(id_curso);

-- 4) PAGO (cuotas por matrícula)
CREATE TABLE pago (
                      id_pago      UUID PRIMARY KEY,
                      fecha_pago   TIMESTAMP NOT NULL DEFAULT NOW(),
                      importe      NUMERIC(12,2) NOT NULL CHECK (importe > 0),
                      metodo       metodo_pago NOT NULL,
                      id_matricula UUID NOT NULL REFERENCES matricula(id_matricula) ON DELETE CASCADE
);

CREATE INDEX ix_pago_matricula ON pago(id_matricula);
