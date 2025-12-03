unit AlumnosView; 

interface
    uses Alumno, Contexto;
    
    procedure MenuAlumnos(var ctx: T_CONTEXTO_ALUMNOS);
    procedure AgregarAlumno(var ctx: T_CONTEXTO_ALUMNOS);
    procedure DarDeBajoAlumno(var ctx: T_CONTEXTO_ALUMNOS);
    procedure ModificarAlumnoView(var ctx: T_CONTEXTO_ALUMNOS);
    procedure ConsultarAlumno(alumnos: NODO_ALUMNO_DNI);
    procedure ListarAlumnos(alumnos: NODO_ALUMNO_NOMBRE);

implementation
    uses 
        Crt, 
        SysUtils, Utils, ViewUtils, List,
        ControllerAlumno;

    procedure AgregarAlumno(var ctx: T_CONTEXTO_ALUMNOS);
    var 
        nuevo_alumno: T_ALUMNO;
        dni, es_docente: string;
        dni_int: longint;
        res: ALUMNO_RES_CONTROLLER;
    begin
        repeat
            Write('DNI: ');
            Readln(dni);
        until TryStrToInt(dni, dni_int);

        nuevo_alumno.dni:= dni_int;

        Write('Nombre: ');
        Readln(nuevo_alumno.nombre);
        Write('Apellido: ');
        Readln(nuevo_alumno.apellido);
        Write('Fecha Nacimiento: ');
        nuevo_alumno.fecha_nacimiento:= IngresarFecha();

        repeat
            Write('Es docente UTN? S/N: ');
            Readln(es_docente);
        until((es_docente = 'S') OR (es_docente = 'N')); 

        if (es_docente = 'S') then 
            nuevo_alumno.docente_utn:= true 
        else 
            nuevo_alumno.docente_utn:= false;

        res:= CrearAlumno(nuevo_alumno, ctx);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln;
            MostrarAlumno(res.data.cab^.info);
            LiberarAlumnoRes(res.data);
        end else 
            begin
                Clrscr;
                Writeln(res.msg);
            end;
    end;

    procedure ConsultarAlumno(alumnos: NODO_ALUMNO_DNI);
    var
        dni: string;
        dni_int: longint;
        res: ALUMNO_RES_CONTROLLER;
    begin
        repeat
            Write('DNI: ');
            Readln(dni);
        until TryStrToInt(dni, dni_int);

        res:= ObtenerAlumno(dni, alumnos);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln;
            MostrarAlumno(res.data.cab^.info);
            LiberarAlumnoRes(res.data);
        end else
        begin
            Writeln(res.msg);
        end; 
    end;

    procedure ListarAlumnos(alumnos: NODO_ALUMNO_NOMBRE);
    var 
        res: ALUMNO_RES_CONTROLLER;
        A: T_ALUMNO;
    begin
        res:= ObtenerAlumnos(alumnos);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln('[ALUMNOS]: Presione una tecla para mostrar los alumnos...');
            Readkey;

            PRIMERO_LISTA_ALUMNOS(res.data);

            while RECUPERAR_LISTA_ALUMNOS(res.data, A) do 
            begin
                Writeln;
                MostrarAlumno(A);
                SIGUIENTE_LISTA_ALUMNOS(res.data);
                Readkey;
            end;

            LiberarAlumnoRes(res.data);
        end else 
            Writeln(res.msg);
    end;

    procedure ModificarAlumnoView(var ctx: T_CONTEXTO_ALUMNOS);
    var
        dni: string;
        dni_int: longint;
        alumno_actualizado: T_ALUMNO;
        input: string;

        res_buscar_alumno: ALUMNO_RES_CONTROLLER;
        res_modificar_alumno: ALUMNO_RES_CONTROLLER;
    begin
        repeat
            Write('DNI: ');
            Readln(dni);
        until TryStrToInt(dni, dni_int);

        
        res_buscar_alumno:= ObtenerAlumno(dni, ctx.dni);

        if not (res_buscar_alumno.error) then 
        begin
            Clrscr;
            alumno_actualizado:= res_buscar_alumno.data.cab^.info;
            MostrarAlumno(alumno_actualizado);

            repeat
                Writeln;
                Write('Modificar nombre? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    Write('Ingrese nombre: ');
                    Readln(alumno_actualizado.nombre);
                end;
            until((input = 'S') OR (input = 'N'));

            repeat
                Writeln;
                Write('Modificar apellido? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    Write('Ingrese apellido: ');
                    Readln(alumno_actualizado.apellido);
                end;
            until((input = 'S') OR (input = 'N'));

            repeat
                Writeln;
                Write('Modificar fecha de nacimiento? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    Write('Ingrese fecha de nacimiento: ');
                    alumno_actualizado.fecha_nacimiento:= IngresarFecha();
                end;
            until((input = 'S') OR (input = 'N'));

            repeat
                Writeln;
                Write('Modificar es docente de la UTN? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    repeat
                        Writeln;
                        Write('Es docente UTN? S/N: ');
                        Readln(input);
                    until((input = 'S') OR (input = 'N'));

                    if (input = 'S') then 
                        alumno_actualizado.docente_utn:= true 
                    else 
                        alumno_actualizado.docente_utn:= false;
                end;
            until((input = 'S') OR (input = 'N'));

            res_modificar_alumno:= ModificarAlumno(alumno_actualizado, ctx);
            
            ClrScr;
            Writeln(res_modificar_alumno.msg);
            Writeln;
            MostrarAlumno(alumno_actualizado);

            LiberarAlumnoRes(res_buscar_alumno.data);
            LiberarAlumnoRes(res_modificar_alumno.data);
        end else
        begin
            Writeln(res_buscar_alumno.msg);
        end; 
    end;

    procedure DarDeBajoAlumno(var ctx: T_CONTEXTO_ALUMNOS);
    var
        dni: string;
        dni_int: longint;
        res: ALUMNO_RES_CONTROLLER;
    begin
        repeat
            Write('DNI: ');
            Readln(dni);
        until TryStrToInt(dni, dni_int);

        res:= EliminarAlumno(dni, ctx);

        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln;
            MostrarAlumno(res.data.cab^.info);
            LiberarAlumnoRes(res.data);
        end else
        begin
            Writeln(res.msg);
        end; 
    end;

    procedure MenuAlumnos(var ctx: T_CONTEXTO_ALUMNOS);
    var 
        opciones : V_Opciones;
        tecla, op: integer;
    begin
        ClrScr;
        AgregarOpcion(opciones, 'Agregar alumno');
        AgregarOpcion(opciones, 'Consultar alumno');
        AgregarOpcion(opciones, 'Listar alumnos');
        AgregarOpcion(opciones, 'Modificar un alumno');
        AgregarOpcion(opciones, 'Eliminar un alumno');
        AgregarOpcion(opciones, 'Volver');

        op := 0;
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
                            AgregarAlumno(ctx); 
                            ContinuarMenu;
                        end; 
                        1: 
                        begin 
                            Clrscr; 
                            ConsultarAlumno(ctx.dni);
                            ContinuarMenu;
                        end;
                        2: 
                        begin 
                            Clrscr; 
                            ListarAlumnos(ctx.nombre);
                            ContinuarMenu;
                        end;
                        3: 
                        begin 
                            Clrscr; 
                            ModificarAlumnoView(ctx);
                            ContinuarMenu;
                        end;
                        4: 
                        begin 
                            Clrscr; 
                            DarDeBajoAlumno(ctx);
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