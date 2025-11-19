unit ViewUtils;

interface
    const 
        MENSAJE_CONTINUAR = 'Presione cualquier tecla para continuar...';

    type 
        V_Opciones = array of string;

    procedure MostrarMenu(opciones: V_Opciones; op: integer);
    procedure AgregarOpcion(var opciones: V_Opciones; opcion: string);
    procedure ContinuarMenu();
    function DetectarTecla(): integer;

implementation
    uses crt;

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