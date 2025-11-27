unit ControllerAlumno; 

interface
    uses Alumno, AVL;

    type
        ALUMNO_RES_CONTROLLER = record
            error: boolean;
            msg: string; 
            data: LISTA_ALUMNOS; 
        end;

    // Para la respuesta de los controladores
    function CrearAlumnoRes(): ALUMNO_RES_CONTROLLER;
    procedure LiberarAlumnoRes(var L: LISTA_ALUMNOS);

    // Controladores
    function CrearAlumno(alumno: T_ALUMNO; var alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;
    function ObtenerAlumno(dni: string; alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;
    function ObtenerAlumnos(alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;
    function EliminarAlumno(dni: string; var alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER; 
    function ModificarAlumno(alumno_actualizado: T_ALUMNO; var alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;

implementation
    uses DAOAlumno, SysUtils;

    function CrearAlumnoRes(): ALUMNO_RES_CONTROLLER;
    var 
        res: ALUMNO_RES_CONTROLLER;
    begin
        res.error:= false;
        res.msg:= '';
        res.data.cab:= nil;
        res.data.act:= nil;
        res.data.tam:= 0;

        CrearAlumnoRes:= res;
    end;

    procedure LiberarAlumnoRes(var L: LISTA_ALUMNOS);
    var
        aux: PUNT_ITEM;
    begin
        while L.cab <> nil do
        begin
            aux:= L.cab;
            L.cab:= L.cab^.sig;
            Dispose(aux);
        end;

        L.act:= nil;
        L.tam:= 0;
    end;

    function CrearAlumno(alumno: T_ALUMNO; var alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;
    var 
        pos: integer;
        alumno_nodo: T_DATO;
        res: ALUMNO_RES_CONTROLLER;
    begin
        alumno.activo:= true;

        // Escribir en archivo
        pos:= EscribirAlumnoEnArchivo(alumno);

        // Actualizar AVL 
        Str(alumno.dni, alumno_nodo.id);
        alumno_nodo.pos_arch:= pos;
        alumnos_avl:= INSERTAR(alumnos_avl, alumno_nodo);

        // Armar respuesta
        res:= CrearAlumnoRes();

        res.msg:= 'Alumno agregado con exito.';
        AGREGAR_LISTA_ALUMNOS(res.data, alumno);

        CrearAlumno:= res;
    end;

    function ObtenerAlumno(dni: string; alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;
    var 
        pos: integer;
        alumno_buscado: PUNT_NODO;
        alumno: T_ALUMNO;
        res: ALUMNO_RES_CONTROLLER;
    begin
        res:= CrearAlumnoRes();

        // Buscar en AVL
        alumno_buscado:= BUSCAR(alumnos_avl, dni);

        if (alumno_buscado <> nil) then 
        begin
            pos:= alumno_buscado^.info.pos_arch;

            // Leer alumno desde archivo
            LeerAlumnoDesdeArchivo(alumno, pos);

            // Armar respuesta
            res.msg:= 'Alumno obtenido con exito.';
            AGREGAR_LISTA_ALUMNOS(res.data, alumno);
        end else 
        begin
            res.error:= true;
            res.msg:= 'No se encontro un alumno con ese dni.';
        end;

        ObtenerAlumno:= res;
    end;

    function ObtenerAlumnos(alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;
    var res: ALUMNO_RES_CONTROLLER;
        procedure RecorrerAVL(N: PUNT_NODO; var L: LISTA_ALUMNOS);
        var 
            alumno: T_ALUMNO;
        begin
            if (N <> nil) then
            begin
                RecorrerAVL(N^.sai, L);

                LeerAlumnoDesdeArchivo(alumno, N^.info.pos_arch);
                AGREGAR_LISTA_ALUMNOS(L, alumno);

                RecorrerAVL(N^.sad, L);
            end;
        end;
    begin
        res:= CrearAlumnoRes();

        if (alumnos_avl = nil) then
        begin
            res.error:= true;
            res.msg:= 'No hay alumnos cargados.';
            ObtenerAlumnos:= res;
        end else 
        begin

            // Recorrer AVL y llenar la lista
            PRIMERO_LISTA_ALUMNOS(res.data);
            RecorrerAVL(alumnos_avl, res.data);
            res.msg:= 'Se encontraron ' + IntToStr(res.data.tam) + ' alumnos.';
        end;

        ObtenerAlumnos:= res;
    end;

    function EliminarAlumno(dni: string; var alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER; 
    var
        pos: integer;
        alumno_buscado: PUNT_NODO;
        alumno: T_ALUMNO;
        res: ALUMNO_RES_CONTROLLER;
    begin
        res:= CrearAlumnoRes();

        // Buscar en el AVL
        alumno_buscado:= BUSCAR(alumnos_avl, dni);

        if (alumno_buscado <> nil) then 
        begin
            pos:= alumno_buscado^.info.pos_arch;

            LeerAlumnoDesdeArchivo(alumno, pos);
            alumno.activo:= false;

            // Eliminar de Archivo
            ModificarAlumnoDeArchivo(alumno, pos);

            // Eliminar de AVL
            alumnos_avl:= ELIMINAR(alumnos_avl, alumno_buscado^.info);

            // Armar respuesta
            res.msg:= 'Alumno dado de baja con exito.';
            AGREGAR_LISTA_ALUMNOS(res.data, alumno);
        end 
        else 
        begin
            res.error:= true;
            res.msg:= 'No se encontro un alumno con ese dni.';
        end;

        EliminarAlumno:= res;
    end;

    function ModificarAlumno(alumno_actualizado: T_ALUMNO; var alumnos_avl: PUNT_NODO): ALUMNO_RES_CONTROLLER;
    var 
        pos: integer;
        alumno_buscado: PUNT_NODO;
        res: ALUMNO_RES_CONTROLLER;
    begin
        res:= CrearAlumnoRes();
        
        alumno_buscado:= BUSCAR(alumnos_avl, IntToStr(alumno_actualizado.dni));
        pos:= alumno_buscado^.info.pos_arch;

        // Modificar en Archivo
        ModificarAlumnoDeArchivo(alumno_actualizado, pos);

        // Armar respuesta
        res.msg:= 'Alumno modificado con exito.';
        AGREGAR_LISTA_ALUMNOS(res.data, alumno_actualizado);

        ModificarAlumno:= res;
    end;

end.