unit InscripcionesView; 

interface
    uses Inscripcion, Contexto, List;

    procedure MostrarInscripcion(I: T_DATO_LISTA_INSCRIPCIONES);

    procedure MenuInscripciones(var ctx: T_CONTEXTO);
    procedure AgregarInscripcion(var ctx: T_CONTEXTO);
    procedure DarDeBajaInscripcion(var ctx: T_CONTEXTO);
    procedure ConsultarInscripcion(var ctx: T_CONTEXTO);
    procedure ListarInscripciones(var ctx: T_CONTEXTO);
    procedure CambiarCondicionAlumno(var ctx: T_CONTEXTO);

implementation
    uses 
        Crt, SysUtils, ViewUtils, ControllerInscripcion;

    procedure MostrarInscripcion(I: T_DATO_LISTA_INSCRIPCIONES);
    begin
        Writeln('Inscripcion: (Codigo): ', I.inscripcion.id);
        Writeln('Capacitacion: ', I.capacitacion.nombre,' (Codigo): ', I.capacitacion.id);
        Writeln('Alumno: ', I.alumno.nombre, ' ', I.alumno.apellido, ' (DNI): ', I.alumno.dni);

        if (I.inscripcion.condicion = Aprobado) then
            Writeln('Condicion: Aprobado')
        else 
            Writeln('Condicion: Asistencia');

    end;

    procedure AgregarInscripcion(var ctx: T_CONTEXTO);
    var 
        nueva_inscripcion: T_INSCRIPCION;
        dni, id: string;
        dni_int, id_int: longint;
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        repeat
            Write('DNI del alumno: ');
            Readln(dni);
        until TryStrToInt(dni, dni_int);

        repeat
            Write('Codigo de capacitacion: ');
            Readln(id);
        until TryStrToInt(id, id_int);

        nueva_inscripcion.dni_alumno:= dni_int;
        nueva_inscripcion.id_capacitacion:= id_int;

        res:= CrearInscripcion(nueva_inscripcion, ctx);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln;
            MostrarInscripcion(res.data.cab^.info);
            LiberarInscripcionRes(res.data);
        end else 
        begin
            Writeln;
            Writeln(res.msg);
        end;
    end;

    procedure DarDeBajaInscripcion(var ctx: T_CONTEXTO);
    var
        id: string;
        id_int: longint;
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        repeat
            Write('Codigo de inscripcion: ');
            Readln(id);
        until TryStrToInt(id, id_int);

        res:= EliminarInscripcion(id, ctx);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            MostrarInscripcion(res.data.cab^.info);
            LiberarInscripcionRes(res.data);
        end else
        begin
            Writeln(res.msg);
        end; 
    end;
    
    procedure ConsultarInscripcion(var ctx: T_CONTEXTO);
    var
        id: string;
        id_int: longint;
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        repeat
            Write('Codigo de inscripcion: ');
            Readln(id);
        until TryStrToInt(id, id_int);

        res:= ObtenerInscripcion(id, ctx);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln;
            MostrarInscripcion(res.data.cab^.info);
            LiberarInscripcionRes(res.data);
        end else
        begin
            Writeln;
            Writeln(res.msg);
        end;
    end;

    procedure ListarInscripciones(var ctx: T_CONTEXTO);
    var 
        res: INSCRIPCION_RES_CONTROLLER;
        I: T_DATO_LISTA_INSCRIPCIONES;
    begin
        res:= ObtenerInscripciones(ctx);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln('Presione una tecla para mostrar inscripcion.');
            Writeln;

            PRIMERO_LISTA_INSCRIPCION(res.data);

            while RECUPERAR_LISTA_INSCRIPCION(res.data, I) do 
            begin
                Writeln;
                MostrarInscripcion(I);
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

    procedure CambiarCondicionAlumno(var ctx: T_CONTEXTO);
    var
        id: string;
        id_int: longint;
        res: INSCRIPCION_RES_CONTROLLER;
    begin
        repeat
            Write('Codigo de inscripcion: ');
            Readln(id);
        until TryStrToInt(id, id_int);

        res:= ActualizarCondicionInscripcion(id, ctx);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            MostrarInscripcion(res.data.cab^.info);
            LiberarInscripcionRes(res.data);
        end else
        begin
            Writeln(res.msg);
        end;
    end;

    procedure MenuInscripciones(var ctx: T_CONTEXTO);
    var 
        opciones : V_Opciones;
        tecla, op: integer;
    begin
        ClrScr;
        AgregarOpcion(opciones, 'Agregar inscripcion');
        AgregarOpcion(opciones, 'Consultar inscripcion');
        AgregarOpcion(opciones, 'Listar inscripciones');
        AgregarOpcion(opciones, 'Dar de baja una inscripcion');
        AgregarOpcion(opciones, 'Cambiar condicion alumno');
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
                            AgregarInscripcion(ctx); 
                            ContinuarMenu;
                        end; 
                        1: 
                        begin 
                            Clrscr; 
                            ConsultarInscripcion(ctx);
                            ContinuarMenu;
                        end;
                        2: 
                        begin 
                            Clrscr; 
                            ListarInscripciones(ctx);
                            ContinuarMenu;
                        end;
                        3: 
                        begin 
                            Clrscr; 
                            DarDeBajaInscripcion(ctx);
                            ContinuarMenu;
                        end;
                        4: 
                        begin 
                            Clrscr; 
                            CambiarCondicionAlumno(ctx);
                            ContinuarMenu;
                        end;
                        5: 
                        begin 
                            Clrscr; 
                        end;
                    end; 
                end; 
            end;
        until (op = 5) and (tecla = 13);
    end;

end.