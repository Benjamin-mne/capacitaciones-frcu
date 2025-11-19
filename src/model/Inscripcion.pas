unit Inscripcion;

interface
    type
        E_CONDICION_ALUMNO = (Aprobado, Asistencia);

        T_INSCRIPCION = record
            id : integer;
            id_capacitacion: integer;
            dni_alumno: integer;
            condicion: E_CONDICION_ALUMNO;
            estado: boolean;
        end;

implementation
end.