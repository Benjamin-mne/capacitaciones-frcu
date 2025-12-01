unit List; 

interface
    uses Capacitacion, Alumno, Inscripcion;

    type 
    // Capacitacion
        PUNT_ITEM_LISTA_CAPACITACIONES = ^ITEM_LISTA_CAPACITACIONES;

        ITEM_LISTA_CAPACITACIONES = record 
            info: T_CAPACITACION;
            sig: PUNT_ITEM_LISTA_CAPACITACIONES;
        end;

        LISTA_CAPACITACIONES = record
            cab: PUNT_ITEM_LISTA_CAPACITACIONES;
            act: PUNT_ITEM_LISTA_CAPACITACIONES;
            tam: integer;
        end;

    // Alumno
        PUNT_ITEM_LISTA_ALUMNOS = ^ITEM_LISTA_ALUMNOS;

        ITEM_LISTA_ALUMNOS = record 
            info: T_ALUMNO;
            sig: PUNT_ITEM_LISTA_ALUMNOS;
        end;

        LISTA_ALUMNOS = record
            cab: PUNT_ITEM_LISTA_ALUMNOS;
            act: PUNT_ITEM_LISTA_ALUMNOS;
            tam: integer;
        end;

    // Inscripcion
        T_DATO_LISTA_INSCRIPCIONES = record
            inscripcion: T_INSCRIPCION;
            alumno: T_ALUMNO;
            capacitacion: T_CAPACITACION;
        end;

        PUNT_ITEM_LISTA_INSCRIPCION = ^ITEM_LISTA_LISTA_INSCRIPCION;

        ITEM_LISTA_LISTA_INSCRIPCION = record 
            info: T_DATO_LISTA_INSCRIPCIONES;
            sig: PUNT_ITEM_LISTA_INSCRIPCION;
        end;

        LISTA_INSCRIPCION = record
            cab: PUNT_ITEM_LISTA_INSCRIPCION;
            act: PUNT_ITEM_LISTA_INSCRIPCION;
            tam: integer;
        end;

    // Capacitacion
    procedure PRIMERO_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES);
    procedure AGREGAR_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES; var X: T_CAPACITACION);
    procedure SIGUIENTE_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES);
    function RECUPERAR_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES; var X: T_CAPACITACION): boolean;

    // Alumno
    procedure PRIMERO_LISTA_ALUMNOS(var L: LISTA_ALUMNOS);
    procedure AGREGAR_LISTA_ALUMNOS(var L: LISTA_ALUMNOS; var X: T_ALUMNO);
    procedure SIGUIENTE_LISTA_ALUMNOS(var L: LISTA_ALUMNOS);
    function RECUPERAR_LISTA_ALUMNOS(var L: LISTA_ALUMNOS; var X: T_ALUMNO): boolean;

    // Inscripcion
    procedure PRIMERO_LISTA_INSCRIPCION(var L: LISTA_INSCRIPCION);
    procedure AGREGAR_LISTA_INSCRIPCION(var L: LISTA_INSCRIPCION; X: T_DATO_LISTA_INSCRIPCIONES);
    procedure SIGUIENTE_LISTA_INSCRIPCION(var L: LISTA_INSCRIPCION);
    function RECUPERAR_LISTA_INSCRIPCION(var L: LISTA_INSCRIPCION; var X: T_DATO_LISTA_INSCRIPCIONES): boolean;

implementation
    uses SysUtils;
    
    procedure PRIMERO_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES);
    begin
        L.act:= L.cab; 
    end;

    procedure AGREGAR_LISTA_CAPACITACIONES(var L: LISTA_CAPACITACIONES; var X: T_CAPACITACION);
    var
        nodo: PUNT_ITEM_LISTA_CAPACITACIONES;
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

    procedure PRIMERO_LISTA_ALUMNOS(var L: LISTA_ALUMNOS);
    begin
        L.act:= L.cab; 
    end;

    procedure AGREGAR_LISTA_ALUMNOS(var L: LISTA_ALUMNOS; var X: T_ALUMNO);
    var
        nodo: PUNT_ITEM_LISTA_ALUMNOS;
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


    procedure PRIMERO_LISTA_INSCRIPCION(var L:LISTA_INSCRIPCION);
    begin
        L.act:= L.cab; 
    end;

    procedure AGREGAR_LISTA_INSCRIPCION(var L:LISTA_INSCRIPCION; X: T_DATO_LISTA_INSCRIPCIONES);
    var
        nodo: PUNT_ITEM_LISTA_INSCRIPCION;
    begin
        New(nodo);
        nodo^.info:= X;
        nodo^.sig:= L.cab;
        L.cab:= nodo;
        L.tam:= L.tam + 1;
    end;


    procedure SIGUIENTE_LISTA_INSCRIPCION(var L:LISTA_INSCRIPCION);
    begin
        if (L.act <> nil) then
            L.act:= L.act^.sig;
    end;

    function RECUPERAR_LISTA_INSCRIPCION(var L:LISTA_INSCRIPCION; var X: T_DATO_LISTA_INSCRIPCIONES): boolean;
    begin
        if (L.act = nil) then
            RECUPERAR_LISTA_INSCRIPCION:= false
        else
        begin
            X:= L.act^.info;
            RECUPERAR_LISTA_INSCRIPCION:= true;
        end;
    end;
end.
