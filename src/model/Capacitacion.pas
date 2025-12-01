unit Capacitacion; 

interface
    type
        E_TIPO_CAPACITACION = (Curso, Taller, Seminario);
        E_AREA_CAPACITACION = (ISI, LOI, Civil, Electro, General);
        T_DOCENTE = string[50];
        V_DOCENTES = array[1..10] of T_DOCENTE;

        T_CAPACITACION = record 
            id: integer;
            nombre: string[50];
            fecha_inicio: string[12];
            fecha_fin: string[12];
            tipo: E_TIPO_CAPACITACION;
            area: E_AREA_CAPACITACION;
            docentes: V_DOCENTES;
            horas: integer;
            activo: boolean;
        end;

        E_CAMPOS_CAPACITACION = (cc_id, cc_nombre, cc_fecha_inicio, cc_fecha_fin, cc_tipo, cc_area, cc_docentes, cc_horas, cc_activo);
        {
            E_CAMPOS_CAPACITACION se usa principalmente como parámetro del procedimiento 
            CargarCapacitacionesAVL (unit DAOCapacitacion) por cual cc (campo de capacitación) debe armar 
            el arbol.
        }

implementation
end.