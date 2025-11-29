unit Capacitacion; 

interface
    type
        E_TIPO_CAPACITACION = (Curso, Taller, Seminario);
        E_AREA_CAPACITACION = (ISI, LOI, Civil, Electro, General);
        T_DOCENTE = string[50];
        V_DOCENTES = array[1..10] of T_DOCENTE;

        T_CAPACITACION = record 
            id: integer;
            nombre: string[50];
            fecha_inicio: string[12];
            fecha_fin: string[12];
            tipo: E_TIPO_CAPACITACION;
            area: E_AREA_CAPACITACION;
            docentes: V_DOCENTES;
            horas: integer;
            activo: boolean;
        end;

        {
            E_CAMPOS_CAPACITACION se usa principalmente como parámetro del procedimiento 
            CargarCapacitacionesAVL (unit DAOCapacitacion) por cual cc (campo de capacitación) debe armar 
            el arbol.
        }

        E_CAMPOS_CAPACITACION = (cc_id, cc_nombre, cc_fecha_inicio, cc_fecha_fin, cc_tipo, cc_area, cc_docentes, cc_horas, cc_activo);

        PUNT_ITEM = ^ITEM_LISTA;

        ITEM_LISTA = record 
            info: T_CAPACITACION;
            sig: PUNT_ITEM;
        end;

        LISTA_CAPACITACIONES = record
            cab: PUNT_ITEM;
            act: PUNT_ITEM;
            tam: integer;
        end;

    procedure PRIMERO_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES);
    procedure AGREGAR_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES; var X: T_CAPACITACION);
    procedure SIGUIENTE_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES);
    function RECUPERAR_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES; var X: T_CAPACITACION): boolean;

implementation

    procedure PRIMERO_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES);
    begin
        L.act:= L.cab; 
    end;

    procedure AGREGAR_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES; var X: T_CAPACITACION);
    var
        nodo: PUNT_ITEM;
    begin
        New(nodo);
        nodo^.info:= X;
        nodo^.sig:= L.cab;
        L.cab:= nodo;
        L.tam:= L.tam + 1;
    end;


    procedure SIGUIENTE_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES);
    begin
        if (L.act <> nil) then
            L.act:= L.act^.sig;
    end;

    function RECUPERAR_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES; var X: T_CAPACITACION): boolean;
    begin
        if (L.act = nil) then
            RECUPERAR_LISTA_CAPACITACIONES:= false
        else
        begin
            X:= L.act^.info;
            RECUPERAR_LISTA_CAPACITACIONES:= true;
        end;
    end;
end.