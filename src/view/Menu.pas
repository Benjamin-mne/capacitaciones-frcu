unit Menu;

interface
    uses AVL, Contexto;

    procedure MenuPrincipal(var ctx: T_CONTEXTO);

implementation
    uses 
        crt, SysUtils, 
        ViewUtils, CapacitacionesView, AlumnosView, InscripcionesView, ConsultasView;

    procedure MenuPrincipal(var ctx: T_CONTEXTO);
        var 
            opciones : V_Opciones;
            tecla, op: integer;

            alumnos_avl: PUNT_NODO; 
            capacitacion_avl: PUNT_NODO;

        begin
            ClrScr;
            AgregarOpcion(opciones, 'Capacitaciones');
            AgregarOpcion(opciones, 'Alumnos');
            AgregarOpcion(opciones, 'Incripciones');
            AgregarOpcion(opciones, 'Consultas');
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
                                MenuCapacitaciones(ctx.capacitaciones);
                            end; 
                            1: 
                            begin 
                                Clrscr; 
                                MenuAlumnos(ctx.alumnos);
                            end; 
                            2: 
                            begin 
                                Clrscr; 
                                MenuInscripciones(ctx);
                            end; 
                            3: 
                            begin 
                                Clrscr; 
                                MenuConsultas(ctx);
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