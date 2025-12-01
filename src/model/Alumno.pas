unit Alumno;

interface
    type
        T_ALUMNO = record
            dni: longint;
            nombre: string[50];
            apellido: string[50];
            fecha_nacimiento: string[12];
            docente_utn: boolean;
            activo: boolean;
        end;

        E_CAMPOS_ALUMNO = (ca_dni, ca_nombre, ca_apellido, ca_fecha_nacimiento, docente_utn, activo);
        {
            E_CAMPOS_ALUMNO se usa principalmente como parámetro del procedimiento 
            CargarAlumnosAVL(unit DAOAlumno) por cual ca (campo de alumno) debe armar 
            el arbol.
        }

implementation
end.
