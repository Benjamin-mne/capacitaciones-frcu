unit ConsultasView; 

interface
    uses Inscripcion, Contexto, List;

    procedure MenuConsultas(var ctx: T_CONTEXTO);
    procedure ListarCapacitacionesDeUnAlumno(var ctx: T_CONTEXTO);
    procedure ListarAlumnosAprobadosDeUnaCapacitacion(var ctx: T_CONTEXTO);
    procedure ListarCapacitacionesDeUnIntervalo(var ctx: T_CONTEXTO);
    procedure MostrarPorcentajeDistribucion(var ctx: T_CONTEXTO);

implementation
    uses 
        Crt, SysUtils, ViewUtils, ControllerInscripcion;

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
            Writeln('[CAPACITACIONES]: ');
            Writeln('Presione una tecla para mostrar las capacitaciones...');
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
            Writeln('[ALUMNOS]: ');
            Writeln('Presione una tecla para mostrar los alumnos...');
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
        end;
    end;


    procedure ListarCapacitacionesDeUnIntervalo(var ctx: T_CONTEXTO);
    begin
        Write('Todo...')
    end;


    procedure MostrarPorcentajeDistribucion(var ctx: T_CONTEXTO);
    begin
        Write('Todo...')
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