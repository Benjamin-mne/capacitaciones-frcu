unit ABBCapacitacionID;

interface
    type
        ABB_CAPACITACION_ID = record
            id: integer;
            pos_arch: integer;
        end;

        PUNT_ABB_CAPACITACION_NODO = ^ABB_CAPACITACION_NODO;

        ABB_CAPACITACION_NODO = record
            info: ABB_CAPACITACION_ID;
            sai: PUNT_ABB_CAPACITACION_NODO;
            sad: PUNT_ABB_CAPACITACION_NODO;
        end;

    procedure CrearABBCapacitacionID(var raiz: PUNT_ABB_CAPACITACION_NODO);
    procedure InsertarABBCapacitacionID(var raiz: PUNT_ABB_CAPACITACION_NODO; dato: ABB_CAPACITACION_ID);
    function  BuscarABBCapacitacionID(raiz: PUNT_ABB_CAPACITACION_NODO; id: integer): PUNT_ABB_CAPACITACION_NODO;
    procedure EliminarABBCapacitacionID(var raiz: PUNT_ABB_CAPACITACION_NODO; id: integer);

implementation

    procedure CrearABBCapacitacionID(var raiz: PUNT_ABB_CAPACITACION_NODO);
    begin
        raiz := nil;
    end;

    procedure InsertarABBCapacitacionID(var raiz: PUNT_ABB_CAPACITACION_NODO; dato: ABB_CAPACITACION_ID);
    begin
        if raiz = nil then
        begin
            New(raiz);
            raiz^.info := dato;
            raiz^.sai := nil;
            raiz^.sad := nil;
        end
        else if dato.id < raiz^.info.id then
            InsertarABBCapacitacionID(raiz^.sai, dato)
        else if dato.id > raiz^.info.id then
            InsertarABBCapacitacionID(raiz^.sad, dato)
        else
    end;

    function BuscarABBCapacitacionID(raiz: PUNT_ABB_CAPACITACION_NODO; id: integer) : PUNT_ABB_CAPACITACION_NODO;
    begin
        if raiz = nil then
            BuscarABBCapacitacionID := nil
        else if id = raiz^.info.id then
            BuscarABBCapacitacionID := raiz
        else if id < raiz^.info.id then
            BuscarABBCapacitacionID := BuscarABBCapacitacionID(raiz^.sai, id)
        else
            BuscarABBCapacitacionID := BuscarABBCapacitacionID(raiz^.sad, id);
    end;

    // Encuentra el mínimo (para eliminar)
    function Minimo(raiz: PUNT_ABB_CAPACITACION_NODO): PUNT_ABB_CAPACITACION_NODO;
    begin
        if (raiz^.sai = nil) then
            Minimo := raiz
        else
            Minimo := Minimo(raiz^.sai);
    end;

    procedure EliminarABBCapacitacionID(var raiz: PUNT_ABB_CAPACITACION_NODO; id: integer);
    var
        aux: PUNT_ABB_CAPACITACION_NODO;
    begin
        if NOT (raiz = nil) then
        begin
            if id < raiz^.info.id then
                EliminarABBCapacitacionID(raiz^.sai, id)
            else if id > raiz^.info.id then
                EliminarABBCapacitacionID(raiz^.sad, id)
            else
            begin
                // Caso 1 y 2: tiene 0 o 1 hijo
                if (raiz^.sai = nil) then
                begin
                    aux := raiz;
                    raiz := raiz^.sad;
                    Dispose(aux);
                end
                else if (raiz^.sad = nil) then
                begin
                    aux := raiz;
                    raiz := raiz^.sai;
                    Dispose(aux);
                end
                else
                begin
                    // Caso 3: tiene 2 hijos
                    aux := Minimo(raiz^.sad);
                    raiz^.info := aux^.info;
                    EliminarABBCapacitacionID(raiz^.sad, aux^.info.id);
                end;
            end;
        end;
    end;

end.
