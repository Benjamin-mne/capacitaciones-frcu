unit DAOInscripcion;

interface 
    uses Inscripcion, AVL;

    // Para el contexto
    procedure CargarInscripcionesAVL(var arbol_inscripciones: PUNT_NODO; campo: E_CAMPOS_INSCRIPCION);

    // Para los controladores
    function ObtenerSiguienteIdInscripcion(): integer;
    function EscribirInscripcionEnArchivo(inscripcion: T_INSCRIPCION): integer;
    procedure LeerInscripcionDesdeArchivo(var inscripcion: T_INSCRIPCION; pos: integer);
    procedure ModificarInscripcionEnArchivo(inscripcion: T_INSCRIPCION; pos: integer);
    function AlumnoYaInscriptoEnArchivo(dni_alumno: integer; id_capacitacion: integer): boolean;

implementation
    uses SysUtils, DAOUtils;
    const RUTA = './data/inscripciones.dat';

    procedure CargarInscripcionesAVL(var arbol_inscripciones: PUNT_NODO; campo: E_CAMPOS_INSCRIPCION);
        var
        archivo: T_ARCHIVO_INSCRIPCION;
        inscripcion: T_INSCRIPCION;
        inscripcion_dato: T_DATO;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);
        Reset(archivo);

        while not Eof(archivo) do 
        begin
            inscripcion_dato.pos_arch:= FilePos(archivo);

            Read(archivo, inscripcion);

            case campo of
                ci_id: Str(inscripcion.id, inscripcion_dato.id);
            else
                Str(inscripcion.id, inscripcion_dato.id); 
            end;

            if (inscripcion.activo) then 
                arbol_inscripciones:= INSERTAR(arbol_inscripciones, inscripcion_dato);
            end;
    
        Close(archivo);
    end;


    function ObtenerSiguienteIdInscripcion(): integer;
    var 
        archivo : T_ARCHIVO_INSCRIPCION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        ObtenerSiguienteIdInscripcion:= FileSize(archivo) + 1;
        Close(archivo);
    end;

    function EscribirInscripcionEnArchivo(inscripcion: T_INSCRIPCION): integer;
        var 
        archivo : T_ARCHIVO_INSCRIPCION;
        pos: integer;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        pos:= FileSize(archivo);
        Seek(archivo, pos);
        Write(archivo, inscripcion);
        
        Close(archivo);

        EscribirInscripcionEnArchivo:= pos;
    end;

    procedure LeerInscripcionDesdeArchivo(var inscripcion: T_INSCRIPCION; pos: integer);
    var
        archivo: T_ARCHIVO_INSCRIPCION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);

        if (pos >= 0) AND (pos < FileSize(archivo)) then
        begin
            Seek(archivo, pos);
            Read(archivo, inscripcion);
        end;

        Close(archivo);
    end;

    procedure ModificarInscripcionEnArchivo(inscripcion: T_INSCRIPCION; pos: integer);
    var
        archivo: T_ARCHIVO_INSCRIPCION;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);

        Seek(archivo, pos);
        Write(archivo, inscripcion);

        Close(archivo);
    end;

    function AlumnoYaInscriptoEnArchivo(dni_alumno: integer; id_capacitacion: integer): boolean;
    var
        archivo: T_ARCHIVO_INSCRIPCION;
        inscripcion: T_INSCRIPCION;
        res: boolean;
    begin
        res:= false;
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);

        while (not Eof(archivo)) and (not res) do 
        begin
            Read(archivo, inscripcion);
            if (inscripcion.dni_alumno = dni_alumno) and (inscripcion.id_capacitacion = id_capacitacion) and (inscripcion.activo) then 
                res:= true;
        end;

        Close(archivo);

        AlumnoYaInscriptoEnArchivo:= res;
    end;
end.
