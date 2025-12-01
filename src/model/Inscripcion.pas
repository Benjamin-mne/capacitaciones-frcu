unit Inscripcion;

interface
    type
        E_CONDICION_ALUMNO = (Aprobado, Asistencia);

        T_INSCRIPCION = record
            id : integer;
            id_capacitacion: integer;
            dni_alumno: integer;
            condicion: E_CONDICION_ALUMNO;
            activo: boolean;
        end;


        E_CAMPOS_INSCRIPCION = (ci_id, ci_id_capacitacion, ci_dni_alumno, ci_condicion, ci_activo);
        {
            E_CAMPOS_INSCRIPCION se usa principalmente como parámetro del procedimiento 
            CargarInscripcionAVL(unit DAOInscripcion) por cual ci (campo de inscripcion) debe armar 
            el arbol.
        }

implementation
end.