unit Contexto; 

interface 
    uses AVL;
    
    type
        NODO_ALUMNO_DNI = PUNT_NODO;
        NODO_ALUMNO_NOMBRE = PUNT_NODO;

        T_CONTEXTO_ALUMNOS = record
            dni: NODO_ALUMNO_DNI; // Arbol de alumnos ordenado por dni
            nombre: NODO_ALUMNO_NOMBRE; // Arbol de alumnos ordenado por nombre
        end;

        NODO_CAPACITACION_ID = PUNT_NODO;
        NODO_CAPACITACION_NOMBRE = PUNT_NODO;

        T_CONTEXTO_CAPACITACIONES = record
            id: NODO_CAPACITACION_ID; // Arbol de capacitaciones ordenado por id
            nombre: NODO_CAPACITACION_NOMBRE; // Arbol de capacitaciones ordenado por nombre
        end;

        T_CONTEXTO = record
            alumnos: T_CONTEXTO_ALUMNOS;
            capacitaciones: T_CONTEXTO_CAPACITACIONES;
        end;

    procedure INIT_CTX(var ctx: T_CONTEXTO);

implementation
    uses
        Alumno, Capacitacion,
        DAOAlumno, DAOCapacitacion;

    procedure INIT_CTX(var ctx: T_CONTEXTO);
    begin
        CargarAlumnosAVL(ctx.alumnos.dni, ca_dni);
        CargarAlumnosAVL(ctx.alumnos.nombre, ca_nombre);
        CargarCapacitacionesAVL(ctx.capacitaciones.id, cc_id);
        CargarCapacitacionesAVL(ctx.capacitaciones.nombre, cc_nombre);
    end;
end.