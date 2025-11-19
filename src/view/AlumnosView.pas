unit AlumnosView; 

interface
    procedure MenuAlumnos();
    procedure AgregarAlumno();
    procedure ConsultarAlumno();
    procedure ModificarAlumno();
    procedure EliminarAlumno();

implementation
    uses 
        Crt, SysUtils, 
        ViewUtils, ControllerAlumno;

    procedure AgregarAlumno();
    var 
        dni, nombre, apellido, fecha_nac, esDocente : string;
        dniInt : longint;   
    begin
        repeat
            Write('DNI: ');
            Readln(dni);
        until TryStrToInt(dni, dniInt);

        Write('Nombre: ');
        Readln(nombre);
        Write('Apellido: ');
        Readln(apellido);
        Write('Fecha Nacimiento: ');
        Readln(fecha_nac);

        repeat
            Write('Es docente UTN? S/N: ');
            Readln(esDocente);
        until((esDocente = 'S') OR (esDocente = 'N')); 

        CrearAlumno(dniInt, nombre, apellido, fecha_nac, esDocente);
    end;

    procedure ConsultarAlumno();
    begin
        Write('Todo...');
    end;

    procedure ModificarAlumno();
    begin
        Write('Todo...');
    end;
    procedure EliminarAlumno();
    begin
        Write('Todo...');
    end;

    procedure MenuAlumnos();
    var 
        opciones : V_Opciones;
        tecla, op: integer;
    begin
        ClrScr;
        AgregarOpcion(opciones, 'Agregar');
        AgregarOpcion(opciones, 'Consultar');
        AgregarOpcion(opciones, 'Modificar');
        AgregarOpcion(opciones, 'Eliminar');
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
                            AgregarAlumno(); 
                            ContinuarMenu;
                        end; 
                        1: 
                        begin 
                            Clrscr; 
                            ConsultarAlumno();
                            ContinuarMenu;
                        end; 
                        2: 
                        begin 
                            Clrscr; 
                            ModificarAlumno();
                            ContinuarMenu;
                        end;
                        3: 
                        begin 
                            Clrscr; 
                            EliminarAlumno();
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