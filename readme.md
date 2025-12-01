### TODO: 
```
Operaciones CRUD: 
[x] CRUD Capacitaciones.
[x] CRUD Alumnos.
[_] CRUD Inscripciones.

Listados:
[x] Listado de capacitacion ordenado por nombre.
[_] Listado de capacitaciones de un determinado alumno. (Alumno + capcitaciones)
[_] Listado de alumnos aprobados de una capacitacion. (Alumnos + capacitacion)
[_] Generar certificado de cursado o de aprobación de una capacitación

Estadísticas: 
[_] Distribución (cantidad) de cursos, talleres, seminarios entre dos fechas 
[_] % de capacitaciones por área/departamento 
[_] Generar una opción diferente a las anteriores (libre elección)
```

# Arquitectura del Sistema

Este documento describe la arquitectura del sistema y la responsabilidad de cada módulo.  
El diseño sigue una estructura modular para mantener claridad, escalabilidad y mantenibilidad.

---

## Módulo **Model**

El módulo **Model** define las entidades centrales del dominio.  
Cada *unit* representa un tipo de dato persistente, sin incluir lógica de negocio.

### Units del módulo:
- **Alumno.pas**  
  Representa a un alumno inscripto en la facultad.
- **Capacitacion.pas**  
  Define una capacitación ofrecida por la institución.
- **Inscripcion.pas**  
  Modela la inscripción de un alumno en una capacitación.

Estas estructuras son utilizadas por el resto del sistema para almacenar, validar y manipular información.

---

## Módulo **DAO** (Data Access Object)

El módulo **DAO** encapsula todas las operaciones de acceso a datos.  
Cada *unit* gestiona exclusivamente un archivo binario asociado a un modelo.

### Units del módulo:
- **DAOAlumno.pas** opera sobre `alumnos.dat`.
- **DAOCapacitacion.pas** opera sobre `capacitaciones.dat`.

Las DAO realizan:
- Lectura y escritura en archivos.
- Búsqueda por posición.
- Actualización de registros.
- Eliminación lógica.

El resto del sistema no conoce la estructura interna de los archivos.

---

## Módulo **Context**

El módulo **Context** funciona como un índice en memoria.  
Utiliza árboles binarios de búsqueda auto–equilibrados (AVL) para mejorar la eficiencia en las consultas.

Cada árbol almacena:
- Una **clave de ordenamiento** (p. ej., `dni`, `id`, etc.).
- La **posición en el archivo** donde se encuentra el registro.

Este módulo:
- Proporciona acceso directo a posiciones de archivo.
- Mantiene los índices actualizados tras cada operación CRUD.
- Permite búsquedas rápidas e independientes de la estructura de persistencia.

---

## Módulo **Controller**

El módulo **Controller** implementa la lógica de negocio del sistema.

Responsabilidades:
- Recibir el contexto y los datos provistos por la vista.
- Validar la operación solicitada.
- Interactuar con el DAO para leer o escribir datos.
- Actualizar los árboles del contexto.
- Construir una respuesta consistente para la vista (mensaje + datos).

Ningún controlador accede directamente a la interfaz o a los archivos.

---

## Módulo **View**

El módulo **View** se encarga de la interacción con el usuario.

Funciones:
- Recibir los inputs ingresados.
- Determinar qué operación CRUD se desea ejecutar.
- Invocar el controlador correspondiente, pasando el contexto y los datos necesarios.
- Mostrar la respuesta generada por el controlador.

La vista no procesa información ni modifica archivos: sólo muestra y solicita datos.

---

## Flujo General del Programa

1. **Main** inicializa el contexto.
2. El contexto es enviado a los controladores.
3. El usuario selecciona una operación CRUD.
4. La vista obtiene los datos y llama al controlador correspondiente.
5. El controlador:
   - Accede mediante DAO a los archivos.
   - Modifica los registros necesarios.
   - Actualiza el contexto.
   - Construye una respuesta.
6. La vista muestra el resultado en pantalla.

Este flujo garantiza separación de responsabilidades y coherencia en la arquitectura general.

---

## Beneficios de Esta Arquitectura

- Mantenibilidad elevada.
- Escalabilidad sin afectar los demás módulos.
- Claridad entre capas: Modelo ↔ DAO ↔ Contexto ↔ Controlador ↔ Vista.
- Facilidad para agregar nuevas entidades o tipos de operaciones.
- Seguridad y encapsulamiento en el acceso a archivos.