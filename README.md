# Sistema de Gestión de Historia Clínica Electrónica (HCE)

Este repositorio contiene el desarrollo completo del método de caso de la Unidad 6 de la asignatura **Bases de Datos**, enfocado en el diseño e implementación de un sistema de **Historia Clínica Electrónica (HCE)** utilizando SQL Server.

## 📚 Contexto

Como administrador de bases de datos en el área de la salud, se diseñó una base de datos relacional siguiendo buenas prácticas de modelado, normalización e implementación SQL para garantizar la integridad, disponibilidad y eficiencia de la información clínica.

---

## 🛠️ Contenido del proyecto

### 1. 🧱 Modelo entidad-relación (MER)
- Diseño conceptual con entidades: Paciente, Médico, Consulta Médica, Historial Médico, Receta, Medicamento, etc.

### 2. 🧾 Scripts SQL incluidos
- `CREATE TABLE`: Definición de tablas con claves primarias y foráneas.
- `CREATE VIEW`: Vistas clínicas útiles para el personal médico.
- `CREATE FUNCTION`: Función para calcular la edad de los pacientes.
- `CREATE PROCEDURE`: Procedimiento para registrar consultas médicas.
- `CREATE INDEX`: Índices agrupados y no agrupados para optimización.
- `DML`: Sentencias `INSERT`, `UPDATE`, `DELETE` y consultas con `JOIN`, `GROUP BY`, `WHERE`, etc.

### 3. 📊 Evidencia técnica
- Capturas de pantalla de ejecuciones exitosas en SQL Server.
- Consultas reales sobre el sistema HCE.

---

## 💡 Objetivos cumplidos

- Garantizar la integridad de los datos clínicos.
- Aplicar técnicas de normalización hasta 3FN.
- Diseñar una base escalable, optimizada y segura.
- Desarrollar evidencia funcional de una base HCE realista.
- Implementar funciones agregadas y consultas SQL complejas.

---

## 📁 Archivos principales

- `hce_script_completo.sql`: Script con todas las sentencias SQL comentadas.
- `README.md`: Este archivo.
- `evidencia/`: Carpeta opcional con capturas de pantalla.




