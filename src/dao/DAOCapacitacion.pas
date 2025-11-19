unit DAOCapacitacion;

interface 
    uses Capacitacion;

    function ObtenerSiguienteIdCapacitacion(): integer;
    procedure EscribirCapacitacionEnArchivo(capacitacion : T_CAPACITACION);
    procedure LeerCapacitacionDesdeArchivo(var capacitacion : T_CAPACITACION; pos: integer);

implementation
    uses SysUtils, DAOUtils;
    const RUTA = './data/capacitaciones.dat';

    function ObtenerSiguienteIdCapacitacion(): integer;
    var 
        archivo : T_ARCHIVO_CAPACITACION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        ObtenerSiguienteIdCapacitacion := FileSize(archivo) + 1;
        Close(archivo);
    end;

    procedure EscribirCapacitacionEnArchivo(capacitacion : T_CAPACITACION);
    var 
        archivo : T_ARCHIVO_CAPACITACION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        Seek(archivo, FileSize(archivo));
        Write(archivo, capacitacion);
        Close(archivo);
    end;

    procedure LeerCapacitacionDesdeArchivo(var capacitacion : T_CAPACITACION; pos: integer);
    var
        archivo: T_ARCHIVO_CAPACITACION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);

        if (pos >= 0) AND (pos < FileSize(archivo)) then
        begin
            Seek(archivo, pos);
            Read(archivo, capacitacion);
        end;

        Close(archivo);
    end;

end.