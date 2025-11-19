unit DAOUtils; 

interface
    uses Capacitacion, Alumno; 
    type 
        T_ARCHIVO_CAPACITACION = file of T_CAPACITACION;
        T_ARCHIVO_ALUMNO = file of T_ALUMNO;

    procedure CrearCarpetaSiNoExiste(RUTA : string);

    procedure CrearArchivoEnvioSiNoExiste(RUTA : string; var archivo : T_ARCHIVO_CAPACITACION);
    procedure ChechearCarpetaYArchivoExisten(RUTA : string; var archivo : T_ARCHIVO_CAPACITACION);

    procedure CrearArchivoEnvioSiNoExiste(RUTA : string; var archivo : T_ARCHIVO_ALUMNO);
    procedure ChechearCarpetaYArchivoExisten(RUTA : string; var archivo : T_ARCHIVO_ALUMNO);


implementation
    uses SysUtils;

    procedure CrearCarpetaSiNoExiste(RUTA : string);
    var 
        carpeta: string;
    begin
        carpeta := ExtractFilePath(RUTA);
        
        if not DirectoryExists(carpeta) then
            CreateDir(carpeta);
    end;

    procedure CrearArchivoEnvioSiNoExiste(RUTA : string; var archivo : T_ARCHIVO_CAPACITACION);
    begin
        if not FileExists(RUTA) then
            Rewrite(archivo);
    end;

    procedure ChechearCarpetaYArchivoExisten(RUTA : string; var archivo : T_ARCHIVO_CAPACITACION);
    begin
        CrearCarpetaSiNoExiste(RUTA);
        CrearArchivoEnvioSiNoExiste(RUTA, archivo);
    end;

    procedure CrearArchivoEnvioSiNoExiste(RUTA : string; var archivo : T_ARCHIVO_ALUMNO);
    begin
        if not FileExists(RUTA) then
            Rewrite(archivo);
    end;

    procedure ChechearCarpetaYArchivoExisten(RUTA : string; var archivo : T_ARCHIVO_ALUMNO);
    begin
        CrearCarpetaSiNoExiste(RUTA);
        CrearArchivoEnvioSiNoExiste(RUTA, archivo);
    end;

end.