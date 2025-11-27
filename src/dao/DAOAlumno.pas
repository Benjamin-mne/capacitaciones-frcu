unit DAOAlumno;

interface 
    uses Alumno, AVL;

    procedure CargarAlumnosAVL(var alumnos_avl: PUNT_NODO);


    function EscribirAlumnoEnArchivo(alumno : T_ALUMNO): integer;
    procedure LeerAlumnoDesdeArchivo(var alumno : T_ALUMNO; pos: integer);
    procedure ModificarAlumnoDeArchivo(alumno: T_ALUMNO; pos: integer);

implementation
    uses SysUtils, DAOUtils;
    const RUTA = './data/alumnos.dat';

    procedure CargarAlumnosAVL(var alumnos_avl: PUNT_NODO);
    var
        archivo: T_ARCHIVO_ALUMNO;
        alumno: T_ALUMNO;
        alumno_dato: T_DATO;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);
        Reset(archivo);

        while not Eof(archivo) do 
        begin
            alumno_dato.pos_arch := FilePos(archivo);

            Read(archivo, alumno);

            Str(alumno.dni, alumno_dato.id);

            if (alumno.activo) then 
                alumnos_avl := INSERTAR(alumnos_avl, alumno_dato);
        end;


        Close(archivo);
    end;

    function EscribirAlumnoEnArchivo(alumno : T_ALUMNO): integer;
    var 
        archivo : T_ARCHIVO_ALUMNO;
        pos: integer;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);
        pos := FileSize(archivo);
        Seek(archivo, pos);
        Write(archivo, alumno);

        Close(archivo);

        EscribirAlumnoEnArchivo:= pos;
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

    procedure ModificarAlumnoDeArchivo(alumno: T_ALUMNO; pos: integer);
    var
        archivo: T_ARCHIVO_ALUMNO;
    begin
        Assign(archivo, RUTA);
        ChechearCarpetaYArchivoExisten(RUTA, archivo);

        Reset(archivo);

        Seek(archivo, pos);
        Write(archivo, alumno);

        Close(archivo);
    end;
end.