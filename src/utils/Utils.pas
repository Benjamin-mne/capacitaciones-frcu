unit Utils; 

interface
    function FechaMayorIgual(fecha_a, fecha_b: string): boolean;
    function FechaMenorIgual(fecha_a, fecha_b: string): boolean;

implementation
    uses SysUtils;

    function FechaMayorIgual(fecha_a, fecha_b: string): boolean;
    var
        dia_a, mes_a, anio_a: longint;
        dia_b, mes_b, anio_b: longint;
    begin
        dia_a:= StrToInt(fecha_a[1] + fecha_a[2]);
        mes_a:= StrToInt(fecha_a[4] + fecha_a[5]);
        anio_a:= StrToInt(fecha_a[7] + fecha_a[8] + fecha_a[9] + fecha_a[10]);

        dia_b:= StrToInt(fecha_b[1] + fecha_b[2]);
        mes_b:= StrToInt(fecha_b[4] + fecha_b[5]);
        anio_b:= StrToInt(fecha_b[7] + fecha_b[8] + fecha_b[9] + fecha_b[10]);

        if anio_a > anio_b then
            FechaMayorIgual:= true
        else if anio_a < anio_b then
            FechaMayorIgual:= false
        else if mes_a > mes_b then
            FechaMayorIgual:= true
        else if mes_a < mes_b then
            FechaMayorIgual:= false
        else
            FechaMayorIgual:= (dia_a >= dia_b);
    end;

    function FechaMenorIgual(fecha_a, fecha_b: string): boolean;
    var
        dia_a, mes_a, anio_a: longint;
        dia_b, mes_b, anio_b: longint;
    begin
        dia_a  := StrToInt(fecha_a[1] + fecha_a[2]);
        mes_a  := StrToInt(fecha_a[4] + fecha_a[5]);
        anio_a := StrToInt(fecha_a[7] + fecha_a[8] + fecha_a[9] + fecha_a[10]);

        dia_b  := StrToInt(fecha_b[1] + fecha_b[2]);
        mes_b  := StrToInt(fecha_b[4] + fecha_b[5]);
        anio_b := StrToInt(fecha_b[7] + fecha_b[8] + fecha_b[9] + fecha_b[10]);

        if anio_a < anio_b then
            FechaMenorIgual := true
        else if anio_a > anio_b then
            FechaMenorIgual := false
        else if mes_a < mes_b then
            FechaMenorIgual := true
        else if mes_a > mes_b then
            FechaMenorIgual := false
        else
            FechaMenorIgual := (dia_a <= dia_b);
    end;
end.