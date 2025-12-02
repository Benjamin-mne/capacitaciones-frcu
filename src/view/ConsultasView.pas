unit ConsultasView; 

interface
    uses Inscripcion, Contexto;

    procedure MenuConsultas(var ctx: T_CONTEXTO);
    procedure ListarCapacitacionesDeUnAlumno(var ctx: T_CONTEXTO);
    procedure ListarAlumnosAprobadosDeUnaCapacitacion(var ctx: T_CONTEXTO);
    procedure ListarCapacitacionesDeUnIntervalo(var ctx: T_CONTEXTO);
    procedure MostrarPorcentajeDistribucion(var ctx: T_CONTEXTO);

implementation
    uses 
        Crt, 
        SysUtils, Utils, ViewUtils, List, 
        Capacitacion,
        ControllerInscripcion, ControllerCapacitacion;

    procedure ListarCapacitacionesDeUnAlumno(var ctx: T_CONTEXTO);
    var 
        dni: string;
        dni_int: longint;
        res: INSCRIPCION_RES_CONTROLLER;
        I: T_DATO_LISTA_INSCRIPCIONES;
    begin
        repeat
            Write('Ingrese DNI del alumno: ');
            Readln(dni);
        until TryStrToInt(dni, dni_int);

        res:= ObtenerInscripcionesDeUnAlumno(dni, ctx);

        if not (res.error) then 
        begin
            Writeln;
        
            Clrscr;
            Writeln(res.msg);
            Writeln;

            Writeln('[ALUMNO]: ');
            MostrarAlumno(res.data.cab^.info.alumno);

            Writeln;
            Writeln('[CAPACITACIONES]: Presione una tecla para mostrar las capacitaciones...');
            Readkey;

            PRIMERO_LISTA_INSCRIPCION(res.data);

            while RECUPERAR_LISTA_INSCRIPCION(res.data, I) do 
            begin
                Writeln;
                Writeln('[CODIGO INSCRIPCION]: ', I.inscripcion.id);

                MostrarCapacitacion(I.capacitacion);

                if (I.inscripcion.condicion = Asistencia) then
                    Writeln('Condicion: Asistencia')
                else
                    Writeln('Condicion: Aprobado');

                SIGUIENTE_LISTA_INSCRIPCION(res.data);
                Readkey;
            end;

            LiberarInscripcionRes(res.data);
        end else 
        begin
            Writeln;
            Writeln(res.msg);
        end;
    end;


    procedure ListarAlumnosAprobadosDeUnaCapacitacion(var ctx: T_CONTEXTO);
    var
        id: string;
        id_int: longint;
        res: INSCRIPCION_RES_CONTROLLER;
        I: T_DATO_LISTA_INSCRIPCIONES;
    begin
        repeat
            Write('Ingrese codigo de la capacitacion: ');
            Readln(id);
        until TryStrToInt(id, id_int);

        res:= ObtenerAlumnosAprobadosDeUnaCapacitacion(id, ctx);

        if not (res.error) then 
        begin
            Writeln;
        
            Clrscr;
            Writeln(res.msg);
            Writeln;

            Writeln('[CAPACITACION]: ');
            MostrarCapacitacion(res.data.cab^.info.capacitacion);

            Writeln;
            Writeln('[ALUMNOS]: Presione una tecla para mostrar los alumnos...');
            Readkey;

            PRIMERO_LISTA_INSCRIPCION(res.data);

            while RECUPERAR_LISTA_INSCRIPCION(res.data, I) do 
            begin
                Writeln;
                MostrarAlumno(I.alumno);
                Writeln('Codigo de inscripcion: ', I.inscripcion.id);

                if (I.inscripcion.condicion = Asistencia) then
                    Writeln('Condicion: Asistencia')
                else
                    Writeln('Condicion: Aprobado');

                SIGUIENTE_LISTA_INSCRIPCION(res.data);
                Readkey;
            end;

            LiberarInscripcionRes(res.data);
        end else 
        begin
            Writeln;
            Writeln(res.msg);
            LiberarInscripcionRes(res.data);
        end;
    end;


    procedure ListarCapacitacionesDeUnIntervalo(var ctx: T_CONTEXTO);
    var        
        fecha_a, fecha_b: string;
        res: CAPACITACION_RES_CONTROLLER;
        C: T_CAPACITACION;
    begin
        Writeln('[Fecha Inicio: ]');
        fecha_a:= IngresarFecha();
        Writeln;

        repeat
            Writeln('[Fecha Fin: ]');
            fecha_b:= IngresarFecha();

            if not (FechaMayorIgual(fecha_b, fecha_a)) then 
                Writeln('La fecha de fin debe ser mayor o igual que la fecha de inicio.')

        until(FechaMayorIgual(fecha_b, fecha_a));

        res:= ObtenerCapacitacionesEntreDosFechas(fecha_a, fecha_b, ctx.capacitaciones);

        if not (res.error) then 
        begin
            Writeln;
            Writeln(res.msg);

            Writeln;
            if (res.data.tam > 0) then 
            begin
                Writeln('[CAPACITACIONES]: Presione una tecla para mostrar las capacitaciones...');
                Readkey;
            end;

            PRIMERO_LISTA_CAPACITACIONES(res.data);

            while RECUPERAR_LISTA_CAPACITACIONES(res.data, C) do 
            begin
                Writeln;
                MostrarCapacitacion(C);

                SIGUIENTE_LISTA_CAPACITACIONES(res.data);
                Readkey;
            end;

            LiberarCapacitacionRes(res.data);
        end else 
        begin
            Writeln;
            Writeln(res.msg);
        end;
    end;

    procedure MostrarPorcentajeDistribucion(var ctx: T_CONTEXTO);

        function porcentaje(area: E_AREA_CAPACITACION; ctx: T_CONTEXTO_CAPACITACIONES; total: integer): real;
        var 
            aux_capacitacion: CAPACITACION_RES_CONTROLLER;
        begin
            aux_capacitacion:= ObtenerCapacitacionesPorArea(area, ctx);

            if (aux_capacitacion.data.tam = 0) then 
                porcentaje:= 0
            else 
                porcentaje:= aux_capacitacion.data.tam / total;
        end;

    var 
        capacitaciones: CAPACITACION_RES_CONTROLLER;
        total: integer;
    begin
        capacitaciones:= ObtenerCapacitaciones(ctx.capacitaciones.nombre);
        
        if (capacitaciones.data.tam = 0) then 
            Write('No se encontraron capacitaciones.')
        else 
        begin
            total:= capacitaciones.data.tam;

            Writeln('Porcentaje ISI: ', 100 * porcentaje(ISI, ctx.capacitaciones, total):0:2, '%');
            Writeln('Porcentaje LOI: ', 100 * porcentaje(LOI, ctx.capacitaciones, total):0:2, '%');
            Writeln('Porcentaje Civil: ', 100 * porcentaje(Civil, ctx.capacitaciones, total):0:2, '%');
            Writeln('Porcentaje Electro: ', 100 * porcentaje(Electro, ctx.capacitaciones, total):0:2, '%');
            Writeln('Porcentaje General: ', 100 * porcentaje(General, ctx.capacitaciones, total):0:2, '%');
        end;
    end;

    procedure MenuConsultas(var ctx: T_CONTEXTO);
    var 
        opciones : V_Opciones;
        tecla, op: integer;
    begin
        ClrScr;
        AgregarOpcion(opciones, 'Consultar capacitaciones de un alumno.');
        AgregarOpcion(opciones, 'Consultar alumnos aprobados de una capacitacion.');
        AgregarOpcion(opciones, 'Consultar seminarios disponibles en un intervalo de tiempo');
        AgregarOpcion(opciones, 'Consultar porcentaje de capacitaciones por area/departamento');
        AgregarOpcion(opciones, 'Volver');

        op:= 0;
        repeat  
            MostrarMenu(opciones, op); 
            tecla:= DetectarTecla();

            case tecla of 
                72: // Arriba
                if (op > 0) then 
                    op:=op-1
                else 
                    op:= Length(opciones) - 1;
                80: // Abajo
                if (op < Length(opciones) - 1) then
                    op:=op+1 
                else
                    op:= 0;
                13: // Enter
                begin 
                    case op of 
                        0: 
                        begin 
                            Clrscr; 
                            ListarCapacitacionesDeUnAlumno(ctx); 
                            ContinuarMenu;
                        end; 
                        1: 
                        begin 
                            Clrscr; 
                            ListarAlumnosAprobadosDeUnaCapacitacion(ctx);
                            ContinuarMenu;
                        end;
                        2: 
                        begin 
                            Clrscr; 
                            ListarCapacitacionesDeUnIntervalo(ctx);
                            ContinuarMenu;
                        end;
                        3: 
                        begin 
                            Clrscr; 
                            MostrarPorcentajeDistribucion(ctx);
                            ContinuarMenu;
                        end;
                        4: 
                        begin 
                            Clrscr; 
                        end;
                    end; 
                end; 
            end;
        until (op = 4) and (tecla = 13);
    end;
end.