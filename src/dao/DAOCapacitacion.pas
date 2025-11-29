unit DAOCapacitacion;

interface 
    uses Capacitacion, AVL;

    // Para el contexto
    procedure CargarCapacitacionesAVL(var capacitacion_avl: PUNT_NODO; campo: E_CAMPOS_CAPACITACION);

    // Para los controladores
    function ObtenerSiguienteIdCapacitacion(): integer;
    function EscribirCapacitacionEnArchivo(capacitacion: T_CAPACITACION): integer;
    procedure LeerCapacitacionDesdeArchivo(var capacitacion : T_CAPACITACION; pos: integer);
    procedure ModificarCapacitacionEnArchivo(capacitacion: T_CAPACITACION; pos: integer);

implementation
    uses SysUtils, DAOUtils;
    const RUTA = './data/capacitaciones.dat';

    procedure CargarCapacitacionesAVL(var capacitacion_avl: PUNT_NODO; campo: E_CAMPOS_CAPACITACION);
    var
        archivo: T_ARCHIVO_CAPACITACION;
        capacitacion: T_CAPACITACION;
        capacitacion_dato: T_DATO;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);
        Reset(archivo);

        while not Eof(archivo) do 
        begin
            capacitacion_dato.pos_arch:= FilePos(archivo);

            Read(archivo, capacitacion);

            case campo of
                cc_nombre: capacitacion_dato.id:= capacitacion.nombre;
                cc_id: Str(capacitacion.id, capacitacion_dato.id);
            else
                Str(capacitacion.id, capacitacion_dato.id); 
            end;

            if (capacitacion.activo) then 
                capacitacion_avl:= INSERTAR(capacitacion_avl, capacitacion_dato);
        end;


        Close(archivo);
    end;

    function ObtenerSiguienteIdCapacitacion(): integer;
    var 
        archivo : T_ARCHIVO_CAPACITACION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        ObtenerSiguienteIdCapacitacion:= FileSize(archivo) + 1;
        Close(archivo);
    end;

    function EscribirCapacitacionEnArchivo(capacitacion : T_CAPACITACION): integer;
    var 
        archivo : T_ARCHIVO_CAPACITACION;
        pos: integer;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        pos:= FileSize(archivo);
        Seek(archivo, pos);
        Write(archivo, capacitacion);
        
        Close(archivo);

        EscribirCapacitacionEnArchivo:= pos;
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

    procedure ModificarCapacitacionEnArchivo(capacitacion: T_CAPACITACION; pos: integer);
    var
        archivo: T_ARCHIVO_CAPACITACION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);

        Seek(archivo, pos);
        Write(archivo, capacitacion);

        Close(archivo);
    end;
end.