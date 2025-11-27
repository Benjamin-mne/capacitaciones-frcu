unit Alumno;

interface
    type
        T_ALUMNO = record
            dni: longint;
            nombre: string[50];
            apellido: string[50];
            fecha_nacimiento: string[12];
            docente_utn: boolean;
            activo: boolean;
        end;

        PUNT_ITEM = ^ITEM_LISTA;

        ITEM_LISTA = record 
            info: T_ALUMNO;
            sig: PUNT_ITEM;
        end;

        LISTA_ALUMNOS = record
            cab: PUNT_ITEM;
            act: PUNT_ITEM;
            tam: integer;
        end;

    procedure PRIMERO_LISTA_ALUMNOS(var L: LISTA_ALUMNOS);
    procedure AGREGAR_LISTA_ALUMNOS(var L: LISTA_ALUMNOS; var X: T_ALUMNO);
    procedure SIGUIENTE_LISTA_ALUMNOS(var L: LISTA_ALUMNOS);
    function RECUPERAR_LISTA_ALUMNOS(var L: LISTA_ALUMNOS; var X: T_ALUMNO): boolean;

implementation

    procedure PRIMERO_LISTA_ALUMNOS(var L: LISTA_ALUMNOS);
    begin
        L.act:= L.cab; 
    end;

    procedure AGREGAR_LISTA_ALUMNOS(var L: LISTA_ALUMNOS; var X: T_ALUMNO);
    var
        nodo: PUNT_ITEM;
    begin
        New(nodo);
        nodo^.info:= X;
        nodo^.sig:= L.cab;
        L.cab:= nodo;
        L.tam:= L.tam + 1;
    end;


    procedure SIGUIENTE_LISTA_ALUMNOS(var L: LISTA_ALUMNOS);
    begin
        if (L.act <> nil) then
            L.act:= L.act^.sig;
    end;

    function RECUPERAR_LISTA_ALUMNOS(var L: LISTA_ALUMNOS; var X: T_ALUMNO): boolean;
    begin
        if (L.act = nil) then
            RECUPERAR_LISTA_ALUMNOS:= false
        else
        begin
            X:= L.act^.info;
            RECUPERAR_LISTA_ALUMNOS:= true;
        end;
    end;
end.
