unit Contexto; 

interface 
    uses 
        AVL,
        Alumno, Capacitacion, Inscripcion, 
        DAOAlumno, DAOCapacitacion, DAOInscripcion;
    
    type
        // Alumno
        NODO_ALUMNO_DNI = PUNT_NODO;
        NODO_ALUMNO_NOMBRE = PUNT_NODO;

        T_CONTEXTO_ALUMNOS = record
            dni: NODO_ALUMNO_DNI; // Arbol de alumnos ordenado por dni
            nombre: NODO_ALUMNO_NOMBRE; // Arbol de alumnos ordenado por nombre
        end;

        // Capacitacion
        NODO_CAPACITACION_ID = PUNT_NODO;
        NODO_CAPACITACION_NOMBRE = PUNT_NODO;

        T_CONTEXTO_CAPACITACIONES = record
            id: NODO_CAPACITACION_ID; // Arbol de capacitaciones ordenado por id
            nombre: NODO_CAPACITACION_NOMBRE; // Arbol de capacitaciones ordenado por nombre
        end;

        // Inscripcion
        NODO_INSCRIPCION_ID = PUNT_NODO;

        T_CONTEXTO_INSCRIPCIONES = record
            id: NODO_INSCRIPCION_ID; // Arbol de inscripciones ordenado por id
        end;

        // Contexto
        T_CONTEXTO = record
            alumnos: T_CONTEXTO_ALUMNOS;
            capacitaciones: T_CONTEXTO_CAPACITACIONES;
            inscripciones: T_CONTEXTO_INSCRIPCIONES;
        end;

    procedure INIT_CTX(var ctx: T_CONTEXTO);

implementation
    procedure INIT_CTX(var ctx: T_CONTEXTO);
    begin
        CargarAlumnosAVL(ctx.alumnos.dni, ca_dni);
        CargarAlumnosAVL(ctx.alumnos.nombre, ca_nombre);

        CargarCapacitacionesAVL(ctx.capacitaciones.id, cc_id);
        CargarCapacitacionesAVL(ctx.capacitaciones.nombre, cc_nombre);
        
        CargarInscripcionesAVL(ctx.inscripciones.id, ci_id);
    end;
end.