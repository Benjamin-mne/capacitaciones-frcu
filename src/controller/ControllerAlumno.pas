unit ControllerAlumno; 

interface
    uses 
        Alumno, Contexto, 
        AVL, List;

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
    function CrearAlumno(alumno: T_ALUMNO; var ctx: T_CONTEXTO_ALUMNOS): ALUMNO_RES_CONTROLLER;
    function ObtenerAlumno(dni: string; arbol_alumnos: NODO_ALUMNO_DNI): ALUMNO_RES_CONTROLLER;
    function ObtenerAlumnos(arbol_alumnos: NODO_ALUMNO_NOMBRE): ALUMNO_RES_CONTROLLER;
    function EliminarAlumno(dni: string; var ctx: T_CONTEXTO_ALUMNOS): ALUMNO_RES_CONTROLLER;
    function ModificarAlumno(alumno_actualizado: T_ALUMNO; var ctx: T_CONTEXTO_ALUMNOS): ALUMNO_RES_CONTROLLER;

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
        aux: PUNT_ITEM_LISTA_ALUMNOS;
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

    function CrearAlumno(alumno: T_ALUMNO; var ctx: T_CONTEXTO_ALUMNOS): ALUMNO_RES_CONTROLLER;
    var 
        pos: integer;
        nodo_dni: T_DATO;
        nodo_nombre: T_DATO;
        res: ALUMNO_RES_CONTROLLER;
    begin
        alumno.activo:= true;

        // Escribir en archivo
        pos:= EscribirAlumnoEnArchivo(alumno);

        // Actualizar Árbol ordenado por dni
        Str(alumno.dni, nodo_dni.id);
        nodo_dni.pos_arch:= pos;
        ctx.dni:= INSERTAR(ctx.dni, nodo_dni);

        // Actualizar Árbol ordenado por nombre
        nodo_nombre.id:= alumno.nombre;
        nodo_nombre.pos_arch:= pos;
        ctx.nombre:= INSERTAR(ctx.nombre, nodo_nombre);


        // Armar respuesta
        res:= CrearAlumnoRes();

        res.msg:= 'Alumno agregado con exito.';
        AGREGAR_LISTA_ALUMNOS(res.data, alumno);

        CrearAlumno:= res;
    end;

    function ObtenerAlumno(dni: string; arbol_alumnos: NODO_ALUMNO_DNI): ALUMNO_RES_CONTROLLER;
    var 
        pos: integer;
        alumno_buscado: NODO_ALUMNO_DNI;
        alumno: T_ALUMNO;
        res: ALUMNO_RES_CONTROLLER;
    begin
        res:= CrearAlumnoRes();

        // Buscar en AVL
        alumno_buscado:= BUSCAR(arbol_alumnos, dni);

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

    function ObtenerAlumnos(arbol_alumnos: NODO_ALUMNO_NOMBRE): ALUMNO_RES_CONTROLLER;
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

        if (arbol_alumnos = nil) then
        begin
            res.error:= true;
            res.msg:= 'No hay alumnos cargados.';
            ObtenerAlumnos:= res;
        end else 
        begin

            // Recorrer arbol de alumnos y llenar la lista
            PRIMERO_LISTA_ALUMNOS(res.data);
            RecorrerAVL(arbol_alumnos, res.data);
            res.msg:= 'Se encontraron ' + IntToStr(res.data.tam) + ' alumnos.';
        end;

        ObtenerAlumnos:= res;
    end;

    function EliminarAlumno(dni: string; var ctx: T_CONTEXTO_ALUMNOS): ALUMNO_RES_CONTROLLER;
    var
        pos: integer;
        alumno_buscado: NODO_ALUMNO_DNI;
        alumno: T_ALUMNO;
        res: ALUMNO_RES_CONTROLLER;
    begin
        res:= CrearAlumnoRes();

        // Buscar en el AVL
        alumno_buscado:= BUSCAR(ctx.dni, dni);

        if (alumno_buscado <> nil) then 
        begin
            pos:= alumno_buscado^.info.pos_arch;

            LeerAlumnoDesdeArchivo(alumno, pos);
            alumno.activo:= false;

            // Eliminar de Archivo
            ModificarAlumnoDeArchivo(alumno, pos);

            // Eliminar nodo del Árbol ordenado por id
            ctx.dni:= ELIMINAR(ctx.dni, alumno_buscado^.info);

            // Actualizar el Árbol ordenado por nombre
            ctx.nombre:= DESTRUIR(ctx.nombre);
            CargarAlumnosAVL(ctx.nombre, ca_nombre);

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

    function ModificarAlumno(alumno_actualizado: T_ALUMNO; var ctx: T_CONTEXTO_ALUMNOS): ALUMNO_RES_CONTROLLER;
    var 
        pos: integer;
        alumno_buscado: NODO_ALUMNO_DNI;
        res: ALUMNO_RES_CONTROLLER;
    begin
        res:= CrearAlumnoRes();
        
        alumno_buscado:= BUSCAR(ctx.dni, IntToStr(alumno_actualizado.dni));
        pos:= alumno_buscado^.info.pos_arch;

        // Modificar en Archivo
        ModificarAlumnoDeArchivo(alumno_actualizado, pos);

        // Actualizar el Árbol ordenado por nombre
        ctx.nombre:= DESTRUIR(ctx.nombre);
        CargarAlumnosAVL(ctx.nombre, ca_nombre);

        // Armar respuesta
        res.msg:= 'Alumno modificado con exito.';
        AGREGAR_LISTA_ALUMNOS(res.data, alumno_actualizado);

        ModificarAlumno:= res;
    end;

end.