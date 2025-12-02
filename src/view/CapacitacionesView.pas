unit CapacitacionesView; 

interface
    uses Capacitacion, Contexto;

    procedure MenuCapacitaciones(var ctx: T_CONTEXTO_CAPACITACIONES);
    procedure AgregarCapacitacion(var ctx: T_CONTEXTO_CAPACITACIONES);
    procedure DarDeBajaCapacitacion(var ctx: T_CONTEXTO_CAPACITACIONES);
    procedure ModificarCapacitacionView(var ctx: T_CONTEXTO_CAPACITACIONES);
    procedure ConsultarCapacitacion(capacitaciones: NODO_CAPACITACION_ID);
    procedure ListarCapacitaciones(capacitaciones: NODO_CAPACITACION_NOMBRE);

implementation
    uses 
        Crt, 
        SysUtils, Utils, ViewUtils, List,
        ControllerCapacitacion;
    
    procedure AgregarCapacitacion(var ctx: T_CONTEXTO_CAPACITACIONES);
    var 
        tipo, area, horas, resAgregarDocente : string;
        horasInt, contadorDocentes, i: longint;
        agregarDocentes: boolean;
        capacitacion: T_CAPACITACION;
    begin
        for i := 1 to 10 do
            capacitacion.docentes[i] := '';

        Write('Nombre: ');
        Readln(capacitacion.nombre);

        Writeln('[Fecha Inicio: ]');
        capacitacion.fecha_inicio:= IngresarFecha();
        Writeln;

        repeat
            Writeln('[Fecha Fin: ]');
            capacitacion.fecha_fin:= IngresarFecha();

            if not (FechaMayorIgual(capacitacion.fecha_fin, capacitacion.fecha_inicio)) then 
                Writeln('La fecha de finalizacion debe ser mayor que la fecha de inicio.')

        until(FechaMayorIgual(capacitacion.fecha_fin, capacitacion.fecha_inicio));

        repeat
            Write('Tipo (curso/taller/seminario): ');
            Readln(tipo);
        until((tipo = 'curso') OR (tipo = 'taller') OR (tipo = 'seminario'));

        if (tipo = 'curso') then 
            capacitacion.tipo:= Curso
        else if (tipo = 'taller') then 
            capacitacion.tipo:= Taller
        else 
            capacitacion.tipo:= Seminario;

        repeat
            Write('Area (isi/loi/civil/electro/general): ');
            Readln(area);
        until((area = 'isi') OR (area = 'loi') OR (area = 'civil') OR (area = 'electro') OR (area = 'general')); 
        
        if (area = 'isi') then 
            capacitacion.area:= ISI 
        else if (area = 'loi') then 
            capacitacion.area:= LOI
        else if (area = 'civil') then 
            capacitacion.area:= Civil 
        else if (area = 'electro') then 
            capacitacion.area:= electro
        else
            capacitacion.area:= General;

        repeat
            Write('Horas: ');
            Readln(horas);
        until TryStrToInt(horas, horasInt);

        capacitacion.horas:= horasInt;

        agregarDocentes := true;
        contadorDocentes := 0;

        repeat
            contadorDocentes := contadorDocentes + 1;
            Write('Nombre y Apellido Docente: ');
            Readln(capacitacion.docentes[contadorDocentes]);

            if contadorDocentes < 10 then
            begin
                repeat
                    Write('Agregar otro docente? S/N: ');
                    Readln(resAgregarDocente);
                until (resAgregarDocente = 'S') OR (resAgregarDocente = 'N');

                if resAgregarDocente = 'N' then
                    agregarDocentes := false;
            end
            else
                agregarDocentes := false;  // ya no hay espacio

        until (NOT agregarDocentes) OR (contadorDocentes = 10);

        CrearCapacitacion(capacitacion, ctx);
    end;

    procedure ConsultarCapacitacion(capacitaciones: NODO_CAPACITACION_ID);
    var
            id: string;
            id_int: longint;
            res: CAPACITACION_RES_CONTROLLER;
        begin
            repeat
                Write('Codigo capacitacion: ');
                Readln(id);
            until TryStrToInt(id, id_int);

            res:= ObtenerCapacitacion(id, capacitaciones);

            if not (res.error) then 
            begin
                Clrscr;
                Writeln(res.msg);
                Writeln;
                MostrarCapacitacion(res.data.cab^.info);
                LiberarCapacitacionRes(res.data);
            end else
            begin
                Writeln(res.msg);
            end; 
        end;

    procedure ListarCapacitaciones(capacitaciones: NODO_CAPACITACION_NOMBRE);
    var 
        res: CAPACITACION_RES_CONTROLLER;
        C: T_CAPACITACION;
    begin
        res:= ObtenerCapacitaciones(capacitaciones);

        if not (res.error) then
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln('[CAPACITACIONES]: Presione una tecla para mostrar las capacitaciones...');
            Readkey;

            PRIMERO_LISTA_CAPACITACIONES(res.data);

            while RECUPERAR_LISTA_CAPACITACIONES(res.data, C) do 
            begin
                Writeln;
                MostrarCapacitacion(C);
                SIGUIENTE_LISTA_CAPACITACIONES(res.data);
                Readkey;
            end;

            LiberarCapacitacionRes(res.data);
        end;

    end;

    procedure ModificarCapacitacionView(var ctx: T_CONTEXTO_CAPACITACIONES);
    var
        id: string;
        id_int, horasInt: longint;
        capacitacion_actualizada: T_CAPACITACION;
        input, tipo, area, horas: string;

        res_buscar_capacitacion: CAPACITACION_RES_CONTROLLER;
        res_modificar_capacitacion: CAPACITACION_RES_CONTROLLER;
    begin
        repeat
            Write('Codigo: ');
            Readln(id);
        until TryStrToInt(id, id_int);

        res_buscar_capacitacion:= ObtenerCapacitacion(id, ctx.id);

        if not (res_buscar_capacitacion.error) then 
        begin
            ClrScr;
            capacitacion_actualizada:= res_buscar_capacitacion.data.cab^.info;
            MostrarCapacitacion(capacitacion_actualizada);

            repeat
                Writeln;
                Write('Modificar nombre? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    Write('Ingrese nombre: ');
                    Readln(capacitacion_actualizada.nombre);
                end;
            until((input = 'S') OR (input = 'N'));

            repeat
                Writeln;
                Write('Modificar fecha de inicio? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    Writeln('[Fecha Inicio: ]');
                    capacitacion_actualizada.fecha_inicio:= IngresarFecha();
                end;
            until((input = 'S') OR (input = 'N'));

            repeat
                if (FechaMayorIgual(capacitacion_actualizada.fecha_fin, capacitacion_actualizada.fecha_inicio)) then 
                begin
                    Writeln;
                    Write('Modificar fecha de finalizacion? S/N: ');
                    Readln(input);
                end else 
                    input:= 'S';

                if (input = 'S') then 
                begin
                    repeat
                        Writeln('[Fecha Fin: ]');
                        capacitacion_actualizada.fecha_fin:= IngresarFecha();

                        if not (FechaMayorIgual(capacitacion_actualizada.fecha_fin, capacitacion_actualizada.fecha_inicio)) then 
                            Writeln('La fecha de finalizacion debe ser mayor que la fecha de inicio.')

                    until(FechaMayorIgual(capacitacion_actualizada.fecha_fin, capacitacion_actualizada.fecha_inicio));
                end;
            until((input = 'S') OR (input = 'N'));

            repeat
                Writeln;
                Write('Modificar tipo? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    repeat
                        Write('Tipo (curso/taller/seminario): ');
                        Readln(tipo);
                    until((tipo = 'curso') OR (tipo = 'taller') OR (tipo = 'seminario'));
                end;
            until((input = 'S') OR (input = 'N'));

            if (tipo = 'curso') then 
                capacitacion_actualizada.tipo:= Curso
            else if (tipo = 'taller') then 
                capacitacion_actualizada.tipo:= Taller
            else 
                capacitacion_actualizada.tipo:= Seminario;

            repeat
                Writeln;
                Write('Modificar area? S/N: ');
                Readln(input);

                if (input = 'S') then 
                begin
                    repeat
                        Write('Area (isi/loi/civil/electro/general): ');
                        Readln(area);
                    until((area = 'isi') OR (area = 'loi') OR (area = 'civil') OR (area = 'electro') OR (area = 'general'));
                end;
            until((input = 'S') OR (input = 'N'));

            if (area = 'isi') then 
                capacitacion_actualizada.area:= ISI 
            else if (area = 'loi') then 
                capacitacion_actualizada.area:= LOI
            else if (area = 'civil') then 
                capacitacion_actualizada.area:= Civil 
            else if (area = 'electro') then 
                capacitacion_actualizada.area:= electro
            else
                capacitacion_actualizada.area:= General;

            repeat
                Writeln;
                Write('Modificar horas? S/N: ');
                Readln(input);

                if (input <> 'N') then 
                begin
                    repeat
                        Write('Horas: ');
                        Readln(horas);
                    until TryStrToInt(horas, horasInt);
                end;
            until((input = 'S') OR (input = 'N'));

            if (input = 'S') then
                capacitacion_actualizada.horas:= horasInt;

            res_modificar_capacitacion:= ModificarCapacitacion(capacitacion_actualizada, ctx);

            ClrScr;
            Writeln(res_modificar_capacitacion.msg);
            Writeln;
            MostrarCapacitacion(capacitacion_actualizada);

            LiberarCapacitacionRes(res_buscar_capacitacion.data);
            LiberarCapacitacionRes(res_buscar_capacitacion.data);
        end else 
        begin
            Writeln(res_buscar_capacitacion.msg);
        end;
    end;

    procedure DarDeBajaCapacitacion(var ctx: T_CONTEXTO_CAPACITACIONES);
    var 
        id: string;
        id_int: longint;
        res: CAPACITACION_RES_CONTROLLER;
    begin
        repeat
            Write('Codigo: ');
            Readln(id);
        until TryStrToInt(id, id_int);

        res:= EliminarCapacitacion(id, ctx);
        
        if not (res.error) then 
        begin
            Clrscr;
            Writeln(res.msg);
            Writeln;
            MostrarCapacitacion(res.data.cab^.info);
            LiberarCapacitacionRes(res.data);
        end else 
        begin
            Writeln(res.msg);
        end;
    end;

    procedure MenuCapacitaciones(var ctx: T_CONTEXTO_CAPACITACIONES);
    var 
        opciones : V_Opciones;
        tecla, op: integer;
    begin
        ClrScr;
        AgregarOpcion(opciones, 'Agregar capacitacion');
        AgregarOpcion(opciones, 'Consultar capacitacion');
        AgregarOpcion(opciones, 'Listar capacitaciones');
        AgregarOpcion(opciones, 'Modificar una capacitacion');
        AgregarOpcion(opciones, 'Eliminar una capacitacion');
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
                            AgregarCapacitacion(ctx); 
                            ContinuarMenu;
                        end; 
                        1: 
                        begin 
                            Clrscr; 
                            ConsultarCapacitacion(ctx.id);
                            ContinuarMenu;
                        end;
                        2: 
                        begin 
                            Clrscr; 
                            ListarCapacitaciones(ctx.nombre);
                            ContinuarMenu;
                        end; 
                        3: 
                        begin 
                            Clrscr; 
                            ModificarCapacitacionView(ctx);
                            ContinuarMenu;
                        end;
                        4: 
                        begin 
                            Clrscr; 
                            DarDeBajaCapacitacion(ctx);
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
