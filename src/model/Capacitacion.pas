unit Capacitacion; 

interface
    type
        E_TIPO_CAPACITACION = (Curso, Taller, Seminario);
        E_AREA_CAPACITACION = (ISI, LOI, Civil, Electro, General);

        T_CAPACITACION = record 
            id: integer;
            nombre: string;
            fecha_inicio: string;
            fecha_fin: string;
            tipo: E_TIPO_CAPACITACION;
            area: E_AREA_CAPACITACION;
            docentes: array [1..10] of string;
            horas: integer;
            estado: boolean;
        end;
        
implementation 
end.