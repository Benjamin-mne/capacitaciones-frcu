unit ControllerInscripcion;

interface
    uses 
        Inscripcion, Contexto, 
        AVL, List;

    type 
        INSCRIPCION_RES_CONTROLLER = record
            error: boolean;
            msg: string;
            data: LISTA_INSCRIPCION; 
        end;

    // Para la respuesta de los controladores
    function CrearInscripcionRes(): INSCRIPCION_RES_CONTROLLER;
    procedure LiberarInscripcionRes(var L: LISTA_INSCRIPCION);

    // Controladores
    function CrearInscripcion(inscripcion: T_INSCRIPCION; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    function ObtenerInscripcion(id: string; ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    function ObtenerInscripciones(ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    function EliminarInscripcion(id: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    function ActualizarCondicionInscripcion(id: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    function ObtenerInscripcionesDeUnAlumno(dni: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    function ObtenerAlumnosAprobadosDeUnaCapacitacion(id: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;


implementation
    uses DAOInscripcion, DAOAlumno, DAOCapacitacion, SysUtils;

    function CrearInscripcionRes(): INSCRIPCION_RES_CONTROLLER;
    var 
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        res.error:= false;
        res.msg:= '';
        res.data.cab:= nil;
        res.data.act:= nil;
        res.data.tam:= 0;

        CrearInscripcionRes:= res;
    end;

    procedure LiberarInscripcionRes(var L: LISTA_INSCRIPCION);
    var
        aux: PUNT_ITEM_LISTA_INSCRIPCION;
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

    function CrearInscripcion(inscripcion: T_INSCRIPCION; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    var 
        pos: integer;
        nodo_id: T_DATO;
        res: INSCRIPCION_RES_CONTROLLER;

        alumno_buscado: NODO_CAPACITACION_ID;
        capacitacion_buscada: NODO_ALUMNO_DNI;
        res_data: T_DATO_LISTA_INSCRIPCIONES;
    begin
        res:= CrearInscripcionRes();
        if(AlumnoYaInscriptoEnArchivo(inscripcion.dni_alumno, inscripcion.id_capacitacion)) then
        begin
            res.error:= true;
            res.msg:= 'El alumno ya esta inscripto en esta capacitacion.';
        end else 
        begin
            alumno_buscado:= BUSCAR(ctx.alumnos.dni, IntToStr(inscripcion.dni_alumno));
            capacitacion_buscada:= BUSCAR(ctx.capacitaciones.id, IntToStr(inscripcion.id_capacitacion));

            if ((alumno_buscado <> nil) and (capacitacion_buscada <> nil)) then 
            begin
                inscripcion.id:= ObtenerSiguienteIdInscripcion();
                inscripcion.activo:= true;
                inscripcion.condicion:= Asistencia;

                // Escribir en archivo
                pos:= EscribirInscripcionEnArchivo(inscripcion);

                // Actualizar Árbol ordenado por id
                Str(inscripcion.id, nodo_id.id);
                nodo_id.pos_arch:= pos;
                ctx.inscripciones.id:= INSERTAR(ctx.inscripciones.id, nodo_id);

                //Crear respuesta
                res_data.inscripcion:= inscripcion;
                LeerAlumnoDesdeArchivo(res_data.alumno, alumno_buscado^.info.pos_arch);
                LeerCapacitacionDesdeArchivo(res_data.capacitacion, capacitacion_buscada^.info.pos_arch);

                res.msg:= 'Inscripcion agregada con exito.';
                AGREGAR_LISTA_INSCRIPCION(res.data, res_data);
            end else if (alumno_buscado = nil) then 
                begin
                    res.error:= true;
                    res.msg:= 'No se encontro alumno con ese dni.';
                end 
            else
            begin
                res.error:= true;
                res.msg:= 'No se encontro capacitacion con ese codigo.';
            end;
        end;

        CrearInscripcion:= res;
    end;

    function ObtenerInscripcion(id: string; ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    var 
        inscripcion_buscada: NODO_INSCRIPCION_ID;
        alumno_buscado: NODO_ALUMNO_DNI;
        capacitacion_buscada: NODO_CAPACITACION_ID;

        pos_arch_inscripcion, pos_arch_alumno, pos_arch_capacitacion: integer;
        res_data: T_DATO_LISTA_INSCRIPCIONES;
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        res:= CrearInscripcionRes();

        // Buscar inscripción en Árbol de inscripciones ordenados por id
        inscripcion_buscada:= BUSCAR(ctx.inscripciones.id, id);

        if (inscripcion_buscada <> nil) then
        begin
            pos_arch_inscripcion:= inscripcion_buscada^.info.pos_arch;
            LeerInscripcionDesdeArchivo(res_data.inscripcion, pos_arch_inscripcion);

            // Buscar en los Árboles de alumnos y capacitaciones ordenados por dni y id respectivamente
            alumno_buscado:= BUSCAR(ctx.alumnos.dni, IntToStr(res_data.inscripcion.dni_alumno));
            capacitacion_buscada:= BUSCAR(ctx.capacitaciones.id, IntToStr(res_data.inscripcion.id_capacitacion));

            pos_arch_alumno:= alumno_buscado^.info.pos_arch;
            pos_arch_capacitacion:= capacitacion_buscada^.info.pos_arch;
            
            // Leer archivo de alumnos y capacitaciones
            LeerAlumnoDesdeArchivo(res_data.alumno, pos_arch_alumno);
            LeerCapacitacionDesdeArchivo(res_data.capacitacion, pos_arch_capacitacion);

            //Crear respuesta
            res.msg:= 'Inscripcion obtenida con exito.';
            AGREGAR_LISTA_INSCRIPCION(res.data, res_data);
        end else 
        begin
            res.error:= true; 
            res.msg:= 'No se encontro inscripcion con ese codigo.'
        end;

        ObtenerInscripcion:= res;
    end;


    function ObtenerInscripciones(ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    var res: INSCRIPCION_RES_CONTROLLER;

        procedure RecorrerAVL(N: PUNT_NODO; var L: LISTA_INSCRIPCION);
        var
            alumno_buscado: NODO_ALUMNO_DNI;
            capacitacion_buscada: NODO_CAPACITACION_ID;
            pos_arch_alumno, pos_arch_capacitacion: integer;

            temp: T_DATO_LISTA_INSCRIPCIONES;
        begin            
            if (N <> nil) then
            begin
                LeerInscripcionDesdeArchivo(temp.inscripcion, N^.info.pos_arch);

                // Buscar en los Árboles de alumnos y capacitaciones ordenados por dni y id respectivamente
                alumno_buscado:= BUSCAR(ctx.alumnos.dni, IntToStr(temp.inscripcion.dni_alumno));
                capacitacion_buscada:= BUSCAR(ctx.capacitaciones.id, IntToStr(temp.inscripcion.id_capacitacion));

                pos_arch_alumno:= alumno_buscado^.info.pos_arch;
                pos_arch_capacitacion:= capacitacion_buscada^.info.pos_arch;

                // Leer archivo de alumnos y capacitaciones
                LeerAlumnoDesdeArchivo(temp.alumno, pos_arch_alumno);
                LeerCapacitacionDesdeArchivo(temp.capacitacion, pos_arch_capacitacion);

                RecorrerAVL(N^.sai, L);
                AGREGAR_LISTA_INSCRIPCION(L, temp);
                RecorrerAVL(N^.sad, L);
            end;
        end;
    begin
        res:= CrearInscripcionRes();

        if (ctx.inscripciones.id = nil) then
        begin
            res.error:= true;
            res.msg:= 'No hay inscripciones cargadas.';
            ObtenerInscripciones:= res;
        end
        else
        begin
            // Construir la lista
            RecorrerAVL(ctx.inscripciones.id, res.data);

            //Crear respuesta
            res.msg:= 'Se encontraron ' + IntToStr(res.data.tam) + ' inscripciones.';

            ObtenerInscripciones:= res;
        end;
    end;


    function EliminarInscripcion(id: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    var
        inscripcion_buscada: NODO_INSCRIPCION_ID;
        inscripcion: T_INSCRIPCION;

        alumno_buscado: NODO_CAPACITACION_ID;
        capacitacion_buscada: NODO_ALUMNO_DNI;

        pos_arch_inscripcion, pos_arch_alumno, pos_arch_capacitacion: integer;

        res_data: T_DATO_LISTA_INSCRIPCIONES;
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        res:= CrearInscripcionRes();

        // Buscar en Árbol de inscripcion ordneado por id
        inscripcion_buscada:= BUSCAR(ctx.inscripciones.id, id);

        if (inscripcion_buscada <> nil) then 
        begin
            pos_arch_inscripcion:= inscripcion_buscada^.info.pos_arch;

            LeerInscripcionDesdeArchivo(inscripcion, pos_arch_inscripcion);
            inscripcion.activo:= false;

            res_data.inscripcion:= inscripcion;

            // Buscar en los Árboles de alumnos y capacitaciones ordenados por dni y id respectivamente
            alumno_buscado:= BUSCAR(ctx.alumnos.dni, IntToStr(res_data.inscripcion.dni_alumno));
            capacitacion_buscada:= BUSCAR(ctx.capacitaciones.id, IntToStr(res_data.inscripcion.id_capacitacion));

            pos_arch_alumno:= alumno_buscado^.info.pos_arch;
            pos_arch_capacitacion:= capacitacion_buscada^.info.pos_arch;
            
            // Leer archivo de alumnos y capacitaciones
            LeerAlumnoDesdeArchivo(res_data.alumno, pos_arch_alumno);
            LeerCapacitacionDesdeArchivo(res_data.capacitacion, pos_arch_capacitacion);

            // Eliminar de Archivo
            ModificarInscripcionEnArchivo(inscripcion, pos_arch_inscripcion);
            
            // Eliminar nodo del Árbol ordenado por id
            ctx.inscripciones.id:= ELIMINAR(ctx.inscripciones.id, inscripcion_buscada^.info);

            // Armar respuesta
            res.msg:= 'Inscripcion dada de baja con exito.';
            AGREGAR_LISTA_INSCRIPCION(res.data, res_data);
        end 
        else 
        begin
            res.error:= true;
            res.msg:= 'No se encontro una inscripcion con ese codigo.';
        end;

        EliminarInscripcion:= res;
    end;

    function ActualizarCondicionInscripcion(id: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    var 
        inscripcion_buscada: NODO_INSCRIPCION_ID;
        alumno_buscado: NODO_CAPACITACION_ID;
        capacitacion_buscada: NODO_ALUMNO_DNI;

        pos_arch_inscripcion, pos_arch_alumno, pos_arch_capacitacion: integer;

        res_data: T_DATO_LISTA_INSCRIPCIONES;
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        res:= CrearInscripcionRes();

        inscripcion_buscada:= BUSCAR(ctx.inscripciones.id, id);

        if (inscripcion_buscada = nil) then 
        begin
            res.error:= true;
            res.msg:= 'No se encontro una inscripcion con ese codigo.';
        end else
        begin
            pos_arch_inscripcion:= inscripcion_buscada^.info.pos_arch;
            LeerInscripcionDesdeArchivo(res_data.inscripcion, pos_arch_inscripcion);

            // Buscar en los Árboles de alumnos y capacitaciones ordenados por dni y id respectivamente
            alumno_buscado:= BUSCAR(ctx.alumnos.dni, IntToStr(res_data.inscripcion.dni_alumno));
            capacitacion_buscada:= BUSCAR(ctx.capacitaciones.id, IntToStr(res_data.inscripcion.id_capacitacion));

            if (alumno_buscado <> nil) and (capacitacion_buscada <> nil) then 
            begin

                if (res_data.inscripcion.condicion = Aprobado) then
                    res_data.inscripcion.condicion:= Asistencia
                else 
                    res_data.inscripcion.condicion:= Aprobado;

                pos_arch_alumno:= alumno_buscado^.info.pos_arch;
                pos_arch_capacitacion:= capacitacion_buscada^.info.pos_arch;
                
                // Leer archivo de alumnos y capacitaciones
                LeerAlumnoDesdeArchivo(res_data.alumno, pos_arch_alumno);
                LeerCapacitacionDesdeArchivo(res_data.capacitacion, pos_arch_capacitacion);

                // Actualizar en Archivo
                ModificarInscripcionEnArchivo(res_data.inscripcion, pos_arch_inscripcion);

                // Armar respuesta
                res.msg:= 'Se actualizo correctamente la condicion del alumno.';
                AGREGAR_LISTA_INSCRIPCION(res.data, res_data);
            end else 
            begin
                res.error:= true;
                res.msg:= 'No se puede completar la operacion porque el estudiante o capacitacion ya no estan disponibles.';
            end;
        end;

        ActualizarCondicionInscripcion:= res;
    end;

    function ObtenerInscripcionesDeUnAlumno(dni: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    var 
        alumno_buscado: NODO_ALUMNO_DNI;

        todas_las_inscripciones: INSCRIPCION_RES_CONTROLLER;
        inscripciones_filtradas: INSCRIPCION_RES_CONTROLLER;
        temp: T_DATO_LISTA_INSCRIPCIONES;
    begin
        // Buscar en los Árboles de alumnos ordenado por dni
        alumno_buscado:= BUSCAR(ctx.alumnos.dni, dni);

        if (alumno_buscado <> nil) then 
        begin
            todas_las_inscripciones:= ObtenerInscripciones(ctx);

            if not (todas_las_inscripciones.error) then
            begin
                inscripciones_filtradas:= CrearInscripcionRes();
                PRIMERO_LISTA_INSCRIPCION(inscripciones_filtradas.data);

                // Recorrer la lista de todas las capacitaciones
                PRIMERO_LISTA_INSCRIPCION(todas_las_inscripciones.data);

                while RECUPERAR_LISTA_INSCRIPCION(todas_las_inscripciones.data, temp) do
                begin
                    if (IntToStr(temp.alumno.dni) = dni) then
                        AGREGAR_LISTA_INSCRIPCION(inscripciones_filtradas.data, temp);

                    SIGUIENTE_LISTA_INSCRIPCION(todas_las_inscripciones.data);
                end;

                // Armar respuesta
                inscripciones_filtradas.msg:= 'Capacitaciones del alumno obtenidas correctamente.';

                ObtenerInscripcionesDeUnAlumno:= inscripciones_filtradas;
            end else 
                ObtenerInscripcionesDeUnAlumno:= todas_las_inscripciones;
        end else 
        begin
            inscripciones_filtradas.error:= true;
            inscripciones_filtradas.msg:= 'No se encontro un alumno con ese dni.';

            ObtenerInscripcionesDeUnAlumno:= inscripciones_filtradas;
        end;
    end;

    function ObtenerAlumnosAprobadosDeUnaCapacitacion(id: string; var ctx: T_CONTEXTO): INSCRIPCION_RES_CONTROLLER;
    var 
        capacitacion_buscada: NODO_CAPACITACION_ID;

        todas_las_inscripciones: INSCRIPCION_RES_CONTROLLER;
        inscripciones_filtradas: INSCRIPCION_RES_CONTROLLER;
        temp: T_DATO_LISTA_INSCRIPCIONES;
    begin
        inscripciones_filtradas:= CrearInscripcionRes();

        // Buscar capacitación
        capacitacion_buscada:= BUSCAR(ctx.capacitaciones.id, id);

        if (capacitacion_buscada = nil) then
        begin
            inscripciones_filtradas.error:= true;
            inscripciones_filtradas.msg:= 'No existe una capacitacion con ese codigo.';
            ObtenerAlumnosAprobadosDeUnaCapacitacion:= inscripciones_filtradas;
        end
        else
        begin
            // Buscar en los Árboles de capacitaciones ordenado por id
            todas_las_inscripciones:= ObtenerInscripciones(ctx);

            if todas_las_inscripciones.error then
                ObtenerAlumnosAprobadosDeUnaCapacitacion:= todas_las_inscripciones
            else
            begin
                PRIMERO_LISTA_INSCRIPCION(inscripciones_filtradas.data);
                PRIMERO_LISTA_INSCRIPCION(todas_las_inscripciones.data);

                // Recorrer la lista de todas las capacitaciones
                while RECUPERAR_LISTA_INSCRIPCION(todas_las_inscripciones.data, temp) do
                begin
                    if (IntToStr(temp.capacitacion.id) = id) and 
                    (temp.inscripcion.condicion = Aprobado) then
                    begin
                        AGREGAR_LISTA_INSCRIPCION(inscripciones_filtradas.data, temp);
                    end;

                    SIGUIENTE_LISTA_INSCRIPCION(todas_las_inscripciones.data);
                end;

                // Armar respuesta
                if inscripciones_filtradas.data.tam = 0 then
                begin
                    inscripciones_filtradas.error:= true;
                    inscripciones_filtradas.msg:= 'No hay alumnos aprobados en esta capacitacion.';
                end
                else
                    inscripciones_filtradas.msg:= 'Alumnos aprobados obtenidos correctamente.';

                ObtenerAlumnosAprobadosDeUnaCapacitacion:= inscripciones_filtradas;
            end;
        end;
    end;


end.