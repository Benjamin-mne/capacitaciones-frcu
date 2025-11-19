unit DAOAlumno;

interface 
    uses Alumno;

    procedure EscribirAlumnoEnArchivo(alumno : T_ALUMNO);
    procedure LeerAlumnoDesdeArchivo(var alumno : T_ALUMNO; pos: integer);

implementation
    uses SysUtils, DAOUtils;
    const RUTA = './data/alumnos.dat';

    procedure EscribirAlumnoEnArchivo(alumno : T_ALUMNO);
    var 
        archivo : T_ARCHIVO_ALUMNO;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        Seek(archivo, FileSize(archivo));
        Write(archivo, alumno);
        Close(archivo);
    end;

    procedure LeerAlumnoDesdeArchivo(var alumno: T_ALUMNO; pos: integer);
    var
        archivo: T_ARCHIVO_ALUMNO;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);

        if (pos >= 0) AND (pos < FileSize(archivo)) then
        begin
            Seek(archivo, pos);
            Read(archivo, alumno);
        end;

        Close(archivo);
    end;
end.