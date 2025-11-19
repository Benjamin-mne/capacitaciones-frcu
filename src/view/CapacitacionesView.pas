unit CapacitacionesView; 

interface
    procedure MenuCapacitaciones();
    procedure AgregarCapacitacion();
    procedure ConsultarCapacitacion();
    procedure ModificarCapacitacion();
    procedure EliminarCapacitacion();

implementation
    uses 
        Crt, SysUtils, 
        ViewUtils, ControllerCapacitacion;
    
    procedure AgregarCapacitacion();
    var 
        nombre, fecha_inicio, fecha_fin, tipo, area, horas, resAgregarDocente : string; 
        docentes: V_DOCENTES; 
        horasInt, contadorDocentes: longint;
        agregarDocentes : boolean;
    begin
        Write('Nombre: ');
        Readln(nombre);

        Write('Fecha Inicio: ');
        Readln(fecha_inicio);

        Write('Fecha Fin: ');
        Readln(fecha_fin);

        repeat
            Write('Tipo (curso/taller/seminario): ');
            Readln(tipo);
        until((tipo = 'curso') OR (tipo = 'taller') OR (tipo = 'seminario')); 

        repeat
            Write('Area (isi/loi/civil/electro/general): ');
            Readln(area);
        until((area = 'isi') OR (area = 'loi') OR (area = 'civil') OR (area = 'electro') OR (area = 'general')); 

        repeat
            Write('Horas: ');
            Readln(horas);
        until TryStrToInt(horas, horasInt);

        agregarDocentes:= true; 
        contadorDocentes:= 0;

        repeat
            contadorDocentes:= contadorDocentes + 1;
            Write('Nombre y Apellido Docente: ');
            Readln(docentes[contadorDocentes]);

            repeat
                Write('Agregar otro docente? S/N: ');
                Readln(resAgregarDocente);
            until((resAgregarDocente = 'S') OR (resAgregarDocente = 'N'));

            if resAgregarDocente = 'N' then 
                agregarDocentes:= false;

        until (NOT agregarDocentes) AND (contadorDocentes < 10);

        CrearCapacitacion(nombre, fecha_inicio, fecha_fin, tipo, area, docentes, horasInt);
    end;

    procedure ConsultarCapacitacion();
    begin
        Write('Todo...');
    end;

    procedure ModificarCapacitacion();
    begin
        Write('Todo...');
    end;

    procedure EliminarCapacitacion();
    begin
        Write('Todo...');
    end;

    procedure MenuCapacitaciones();
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
                            AgregarCapacitacion(); 
                            ContinuarMenu;
                        end; 
                        1: 
                        begin 
                            Clrscr; 
                            ConsultarCapacitacion();
                            ContinuarMenu;
                        end; 
                        2: 
                        begin 
                            Clrscr; 
                            ModificarCapacitacion();
                            ContinuarMenu;
                        end;
                        3: 
                        begin 
                            Clrscr; 
                            EliminarCapacitacion();
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
