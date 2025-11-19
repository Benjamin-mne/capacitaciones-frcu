unit ControllerCapacitacion; 

interface
    uses 
        SysUtils,
        Capacitacion, DAOCapacitacion;

    type V_DOCENTES = array [1..10] of string;

    procedure CrearCapacitacion(nombre, fecha_inicio, fecha_fin, tipo, area : string; docentes: V_DOCENTES; horas: integer);

implementation

    procedure CrearCapacitacion(nombre, fecha_inicio, fecha_fin, tipo, area : string; docentes: V_DOCENTES; horas: integer);
    var 
        capacitacion : T_CAPACITACION;
    begin

        capacitacion.id:= ObtenerSiguienteIdCapacitacion();
        capacitacion.nombre:= nombre;
        capacitacion.fecha_inicio:= fecha_inicio;
        capacitacion.fecha_fin:= fecha_fin;

        if (tipo = 'curso') then 
            capacitacion.tipo:= Curso
        else if (tipo = 'taller') then 
            capacitacion.tipo:= Taller
        else 
            capacitacion.tipo:= Seminario;
        
        if (area = 'isi') then 
            capacitacion.area:= ISI 
        else if (area = 'loi') then 
            capacitacion.area:= LOI
        else if (area = 'civil') then 
            capacitacion.area:= Civil 
        else if (area = 'electro') then 
            capacitacion.area:= electro
        else
            capacitacion.area:= General;
        
        capacitacion.docentes:= docentes;
        capacitacion.horas:= horas;
        capacitacion.estado:= true;

        EscribirCapacitacionEnArchivo(capacitacion);
    end;

end.