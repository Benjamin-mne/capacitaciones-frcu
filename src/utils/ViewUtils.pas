unit ViewUtils;

interface
    uses Alumno, Capacitacion;

    const 
        MENSAJE_CONTINUAR = 'Presione cualquier tecla para continuar...';

    type 
        V_Opciones = array of string;

    procedure MostrarMenu(opciones: V_Opciones; op: integer);
    procedure AgregarOpcion(var opciones: V_Opciones; opcion: string);
    procedure ContinuarMenu();
    function DetectarTecla(): integer;

    procedure MostrarAlumno(A: T_ALUMNO);
    procedure MostrarCapacitacion(C: T_CAPACITACION);

implementation
    uses crt;
    
    procedure MostrarAlumno(A: T_ALUMNO);
    begin
        with A do
        begin
            Writeln('DNI: ', dni);
            Writeln('Nombre: ', nombre);
            Writeln('Apellido: ', apellido);
            Writeln('Fecha de Nacimiento: ', fecha_nacimiento);
            if docente_utn then
                Writeln('Docente UTN: Si')
            else
                Writeln('Docente UTN: No');

            {
            if activo then
                Writeln('Estado: Activo')
            else
                Writeln('Estado: Inactivo');
            }

        end;
    end;

    procedure MostrarCapacitacion(C: T_CAPACITACION);
    var
        i: integer;
    begin
        with C do
        begin
            Writeln('Codigo: ', id);
            Writeln('Nombre: ', nombre);
            Writeln('Fecha inicio: ', fecha_inicio);
            Writeln('Fecha fin: ', fecha_fin);

            Write('Tipo: ');
            case tipo of
                Curso: Writeln('Curso');
                Taller: Writeln('Taller');
                Seminario: Writeln('Seminario');
            end;

            Write('Area: ');
            case area of
                ISI: Writeln('ISI');
                LOI: Writeln('LOI');
                Civil: Writeln('Civil');
                Electro: Writeln('Electro');
                General: Writeln('General');
            end;

            Writeln('Docentes:');
            for i := 1 to 10 do
            begin
                if docentes[i] <> '' then
                    Writeln('  - ', docentes[i]);
            end;

            Writeln('Horas: ', horas);

            {
            if activo then
                Writeln('Estado: Activo')
            else
                Writeln('Estado: Inactivo');
            }
        end;
    end;

    procedure MostrarMenu(opciones: V_Opciones; op: integer);
    var
        i: integer;
    begin 
        clrscr; 
        for i := 0 to Length(opciones) - 1 do 
        begin 
            if (i = op) then 
            begin 
                textbackground(7); 
                textcolor(0); 
                Writeln(opciones[i], ' '); 
                textcolor(7); 
                textbackground(0); 
            end 
            else 
                Writeln(opciones[i]); 
        end; 
    end;

    procedure AgregarOpcion(var opciones: V_Opciones; opcion: string);
    var
        n: integer;
    begin
        n := Length(opciones);
        SetLength(opciones, n + 1);
        opciones[n] := opcion; 
    end;

    procedure ContinuarMenu();
    begin
        Writeln('');
        Write(MENSAJE_CONTINUAR);
        ReadKey;
    end;

    function DetectarTecla(): integer;
    var
        tecla: integer;
    begin 
        tecla := Ord(ReadKey);
        if tecla = 0 then 
            tecla := Ord(ReadKey);
        DetectarTecla := tecla; 
    end;
end.