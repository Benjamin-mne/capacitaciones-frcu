unit ControllerAlumno; 

interface
    uses Alumno, DAOAlumno, SysUtils;

    procedure CrearAlumno(dni : cardinal; nombre, apellido, fecha_nac, esDocente : string);

implementation

    procedure CrearAlumno(dni : cardinal; nombre, apellido, fecha_nac, esDocente : string);
    var 
        alumno : T_ALUMNO;
    begin
        alumno.dni:= dni;
        alumno.nombre:= nombre;
        alumno.apellido:= apellido;
        alumno.fecha_nacimiento:= fecha_nac;

        if (esDocente = 'S') then 
            alumno.docente_utn:= true 
        else 
            alumno.docente_utn:= false;

        EscribirAlumnoEnArchivo(alumno);
    end;

end.