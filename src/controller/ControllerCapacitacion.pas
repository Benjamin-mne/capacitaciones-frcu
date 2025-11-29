unit ControllerCapacitacion; 

interface
    uses Capacitacion, AVL, Contexto;

    type 
        CAPACITACION_RES_CONTROLLER = record
            error: boolean;
            msg: string;
            data: LISTA_CAPACITACIONES; 
        end;
    
    // Para la respuesta de los controladores
    function CrearCapacitacionRes(): CAPACITACION_RES_CONTROLLER;
    procedure LiberarCapacitacionRes(var L: LISTA_CAPACITACIONES);


    // Controladores
    function CrearCapacitacion(capacitacion: T_CAPACITACION; var ctx: T_CONTEXTO_CAPACITACIONES): CAPACITACION_RES_CONTROLLER;
    function ObtenerCapacitacion(id: string; arbol_capacitaciones: NODO_CAPACITACION_ID): CAPACITACION_RES_CONTROLLER;
    function ObtenerCapacitaciones(arbol_capacitaciones: NODO_CAPACITACION_NOMBRE): CAPACITACION_RES_CONTROLLER;
    function EliminarCapacitacion(id: string; var ctx: T_CONTEXTO_CAPACITACIONES): CAPACITACION_RES_CONTROLLER;
    function ModificarCapacitacion(capacitacion_actualizada: T_CAPACITACION; var ctx: T_CONTEXTO_CAPACITACIONES): CAPACITACION_RES_CONTROLLER;

implementation
    uses DAOCapacitacion, SysUtils;

    function CrearCapacitacionRes(): CAPACITACION_RES_CONTROLLER;
    var 
        res: CAPACITACION_RES_CONTROLLER;
    begin
        res.error:= false;
        res.msg:= '';
        res.data.cab:= nil;
        res.data.act:= nil;
        res.data.tam:= 0;

        CrearCapacitacionRes:= res;
    end;

    procedure LiberarCapacitacionRes(var L: LISTA_CAPACITACIONES);
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

    function CrearCapacitacion(capacitacion: T_CAPACITACION; var ctx: T_CONTEXTO_CAPACITACIONES): CAPACITACION_RES_CONTROLLER;
    var 
        pos: integer;
        nodo_id: T_DATO;
        nodo_nombre: T_DATO;
        res: CAPACITACION_RES_CONTROLLER;
    begin
        capacitacion.id:= ObtenerSiguienteIdCapacitacion();        
        capacitacion.activo:= true;

        // Escribir en archivo
        pos:= EscribirCapacitacionEnArchivo(capacitacion);

        // Actualizar Árbol ordenado por id
        Str(capacitacion.id, nodo_id.id);
        nodo_id.pos_arch:= pos;
        ctx.id:= INSERTAR(ctx.id, nodo_id);

        // Actualizar Árbol ordenado por nombre
        nodo_nombre.id:= capacitacion.nombre;
        nodo_nombre.pos_arch:= pos;
        ctx.nombre:= INSERTAR(ctx.nombre, nodo_nombre);

        // Armar respuesta
        res:= CrearCapacitacionRes();

        res.msg:= 'Capacitacion agregada con exito.';
        AGREGAR_LISTA_CAPACITACIONES(res.data, capacitacion);
    end;

    function ObtenerCapacitacion(id: string; arbol_capacitaciones: NODO_CAPACITACION_ID): CAPACITACION_RES_CONTROLLER;
    var 
        pos: integer;
        capacitacion_buscada: NODO_CAPACITACION_ID;
        capacitacion: T_CAPACITACION;
        res: CAPACITACION_RES_CONTROLLER;
    begin
        res:= CrearCapacitacionRes();

        // Buscar en AVL
        capacitacion_buscada:= BUSCAR(arbol_capacitaciones, id);

        if (capacitacion_buscada <> nil) then 
        begin
            pos:= capacitacion_buscada^.info.pos_arch;

            // Leer capacitacion desde archivo
            LeerCapacitacionDesdeArchivo(capacitacion, pos);

            // Armar respuesta
            res.msg:= 'Capacitacion obtenida con exito.';
            AGREGAR_LISTA_CAPACITACIONES(res.data, capacitacion);
        end else 
        begin
            res.error:= true;
            res.msg:= 'No se encontro un capacitacion con ese codigo.';
        end;

        ObtenerCapacitacion:= res;
    end;

    function ObtenerCapacitaciones(arbol_capacitaciones: NODO_CAPACITACION_NOMBRE): CAPACITACION_RES_CONTROLLER;
    var res: CAPACITACION_RES_CONTROLLER;
        procedure RecorrerAVL(N: NODO_CAPACITACION_NOMBRE; var L: LISTA_CAPACITACIONES);
        var 
            capacitacion: T_CAPACITACION;
        begin
            if (N <> nil) then
            begin
                RecorrerAVL(N^.sai, L);

                LeerCapacitacionDesdeArchivo(capacitacion, N^.info.pos_arch);
                AGREGAR_LISTA_CAPACITACIONES(L, capacitacion);

                RecorrerAVL(N^.sad, L);
            end;
        end;
    begin
        res:= CrearCapacitacionRes();

        if(arbol_capacitaciones = nil) then 
        begin
            res.error:= true;
            res.msg:= 'No hay capacitaciones cargadas.';
            ObtenerCapacitaciones:= res;
        end else 
        begin
            PRIMERO_LISTA_CAPACITACIONES(res.data);
            RecorrerAVL(arbol_capacitaciones, res.data);
            res.msg:= 'Se encontraron ' + IntToStr(res.data.tam) + ' capacitaciones.';
        end;

        ObtenerCapacitaciones:= res;
    end;

    function EliminarCapacitacion(id: string; var ctx: T_CONTEXTO_CAPACITACIONES): CAPACITACION_RES_CONTROLLER;
    var 
        pos: integer;
        capacitacion_buscada: NODO_CAPACITACION_ID;
        capacitacion: T_CAPACITACION;
        res: CAPACITACION_RES_CONTROLLER;
    begin
        res:= CrearCapacitacionRes();

        // Buscar en Árbol ordenado por id
        capacitacion_buscada:= BUSCAR(ctx.id, id);

        if (capacitacion_buscada <> nil) then
        begin
            pos:= capacitacion_buscada^.info.pos_arch;

            LeerCapacitacionDesdeArchivo(capacitacion, pos);
            capacitacion.activo:= false;

            // Eliminar de Archivo
            ModificarCapacitacionEnArchivo(capacitacion, pos);

            // Eliminar nodo del Árbol ordenado por id
            ctx.id:= ELIMINAR(ctx.id, capacitacion_buscada^.info);

            // Actualizar el Árbol ordenadoo por nombre
            ctx.nombre:= DESTRUIR(ctx.nombre);
            CargarCapacitacionesAVL(ctx.nombre, cc_nombre);

            // Armar respuesta
            res.msg:= 'Capacitación dada de baja con exito.';
            AGREGAR_LISTA_CAPACITACIONES(res.data, capacitacion);
        end else 
        begin
            res.error:= true;
            res.msg:= 'No se encontro una capacitacion con ese codigo.';
        end;
        
        EliminarCapacitacion:= res;
    end;

    function ModificarCapacitacion(capacitacion_actualizada: T_CAPACITACION; var ctx: T_CONTEXTO_CAPACITACIONES): CAPACITACION_RES_CONTROLLER;
    var 
        pos: integer;
        capacitacion_buscada: NODO_CAPACITACION_ID;
        res: CAPACITACION_RES_CONTROLLER;
    begin
        res:= CrearCapacitacionRes();

        capacitacion_buscada:= BUSCAR(ctx.id, IntToStr(capacitacion_actualizada.id));
        pos:= capacitacion_buscada^.info.pos_arch;

        // Modificar en archibo
        ModificarCapacitacionEnArchivo(capacitacion_actualizada, pos);

        // Actualizar el Árbol ordenado por nombre; 
        ctx.nombre:= DESTRUIR(ctx.nombre);
        CargarCapacitacionesAVL(ctx.nombre, cc_nombre);

        // Armar respuesta
        res.msg:= 'Capacitacion modificada con exito.';
        AGREGAR_LISTA_CAPACITACIONES(res.data, capacitacion_actualizada);
        
        ModificarCapacitacion:= res;
    end;

end.