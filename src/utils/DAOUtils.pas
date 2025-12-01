unit DAOUtils; 

interface
    uses Capacitacion, Alumno, Inscripcion; 
    type 
        T_ARCHIVO_CAPACITACION = file of T_CAPACITACION;
        T_ARCHIVO_ALUMNO = file of T_ALUMNO;
        T_ARCHIVO_INSCRIPCION = file of T_INSCRIPCION;

    procedure CrearCarpetaSiNoExiste(RUTA: string);
    // Capacitacion
    procedure CrearArchivoEnvioSiNoExiste(RUTA: string; var archivo: T_ARCHIVO_CAPACITACION);
    procedure ChechearCarpetaYArchivoExisten(RUTA: string; var archivo: T_ARCHIVO_CAPACITACION);
    // Alumno
    procedure CrearArchivoEnvioSiNoExiste(RUTA: string; var archivo: T_ARCHIVO_ALUMNO);
    procedure ChechearCarpetaYArchivoExisten(RUTA: string; var archivo: T_ARCHIVO_ALUMNO);
    // Inscripcion
    procedure CrearArchivoEnvioSiNoExiste(RUTA: string; var archivo: T_ARCHIVO_INSCRIPCION);
    procedure ChechearCarpetaYArchivoExisten(RUTA: string; var archivo: T_ARCHIVO_INSCRIPCION);


implementation
    uses SysUtils;

    procedure CrearCarpetaSiNoExiste(RUTA: string);
    var 
        carpeta: string;
    begin
        carpeta := ExtractFilePath(RUTA);
        
        if not DirectoryExists(carpeta) then
            CreateDir(carpeta);
    end;

    procedure CrearArchivoEnvioSiNoExiste(RUTA: string; var archivo: T_ARCHIVO_CAPACITACION);
    begin
        if not FileExists(RUTA) then
            Rewrite(archivo);
    end;

    procedure ChechearCarpetaYArchivoExisten(RUTA: string; var archivo: T_ARCHIVO_CAPACITACION);
    begin
        CrearCarpetaSiNoExiste(RUTA);
        CrearArchivoEnvioSiNoExiste(RUTA, archivo);
    end;

    procedure CrearArchivoEnvioSiNoExiste(RUTA: string; var archivo: T_ARCHIVO_ALUMNO);
    begin
        if not FileExists(RUTA) then
            Rewrite(archivo);
    end;

    procedure ChechearCarpetaYArchivoExisten(RUTA: string; var archivo: T_ARCHIVO_ALUMNO);
    begin
        CrearCarpetaSiNoExiste(RUTA);
        CrearArchivoEnvioSiNoExiste(RUTA, archivo);
    end;

    procedure CrearArchivoEnvioSiNoExiste(RUTA: string; var archivo: T_ARCHIVO_INSCRIPCION);
    begin
        if not FileExists(RUTA) then
            Rewrite(archivo);
    end;

    procedure ChechearCarpetaYArchivoExisten(RUTA: string; var archivo: T_ARCHIVO_INSCRIPCION);
    begin
        CrearCarpetaSiNoExiste(RUTA);
        CrearArchivoEnvioSiNoExiste(RUTA, archivo);
    end;

end.