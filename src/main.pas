program main; 

uses
    AVL, Menu, crt;

procedure PRE_ORDEN(raiz: PUNT_NODO);
begin
    if (raiz <> nil) then 
    begin
        Write(raiz^.info.id, ' ');
        PRE_ORDEN(raiz^.sai);
        PRE_ORDEN(raiz^.sad);
    end;
end; 

var 
    raiz : PUNT_NODO;
    X : T_DATO;

begin
    raiz := nil;

    X.id:= 9;
    X.pos_arch:= 1;
    raiz:= INSERTAR(raiz, X);

    X.id:= 5;
    X.pos_arch:= 2;
    raiz:= INSERTAR(raiz, X);

    X.id:= 10;
    X.pos_arch:= 3;
    raiz:= INSERTAR(raiz, X);

    X.id:= 0;
    X.pos_arch:= 4;
    raiz:= INSERTAR(raiz, X);

    X.id:= 6;
    X.pos_arch:= 5;
    raiz:= INSERTAR(raiz, X);

    X.id:= 11;
    X.pos_arch:= 6;
    raiz:= INSERTAR(raiz, X);

    X.id:= -1;
    X.pos_arch:= 7;
    raiz:= INSERTAR(raiz, X);

    X.id:= 1;
    X.pos_arch:= 8;
    raiz:= INSERTAR(raiz, X);

    X.id:= 2;
    X.pos_arch:= 9;
    raiz:= INSERTAR(raiz, X);

    Clrscr;

    PRE_ORDEN(raiz);
    Writeln;
    Writeln('==== ELIMINAR [10] ==== ');

    X.id:= 10;
    raiz:= ELIMINAR(raiz, X);

    PRE_ORDEN(raiz);

    X:= BUSCAR(raiz, 11)^.info;
    Writeln;
    Writeln;
    Writeln('ID: ', X.id,' POS_ARCH: ', X.pos_arch);

    //MenuPrincipal()
end.
