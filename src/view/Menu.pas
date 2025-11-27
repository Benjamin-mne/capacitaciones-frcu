unit Menu;

interface
    uses AVL;

    procedure MenuPrincipal(var alumnos_avl: PUNT_NODO);
    procedure Listados();
    procedure Estadistica();

implementation
    uses 
        crt, SysUtils, 
        ViewUtils, CapacitacionesView, AlumnosView;

    procedure Listados();
    begin
        Writeln('TODO: Listados..');
    end;
    procedure Estadistica();
    begin
        Writeln('TODO: Estadistica..');
    end;

    procedure MenuPrincipal(var alumnos_avl: PUNT_NODO);
        var 
            opciones : V_Opciones;
            tecla, op: integer;

        begin
            ClrScr;
            AgregarOpcion(opciones, 'Capacitaciones');
            AgregarOpcion(opciones, 'Alumnos');
            AgregarOpcion(opciones, 'Listados');
            AgregarOpcion(opciones, 'Estadistica');
            AgregarOpcion(opciones, 'Salir');

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
                                MenuCapacitaciones(); 
                            end; 
                            1: 
                            begin 
                                Clrscr; 
                                MenuAlumnos(alumnos_avl);
                            end; 
                            2: 
                            begin 
                                Clrscr; 
                                Listados();
                                ContinuarMenu;
                            end;
                            3: 
                            begin 
                                Clrscr; 
                                Estadistica();
                                ContinuarMenu;
                            end;
                            4: 
                            begin 
                                Clrscr; 
                                Writeln('Saliendo...');
                            end;
                        end; 
                    end; 
                end;
            until (op = 4) and (tecla = 13);
        end;

end.