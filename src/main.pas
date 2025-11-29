program main; 

uses
    //AVL, 
    Contexto, Menu, 
    crt;

{
    procedure INORDEN(raiz: PUNT_NODO);
    begin
        if raiz <> nil then
        begin
            INORDEN(raiz^.sai);
            Writeln('ID: ', raiz^.info.id, '  Pos: ', raiz^.info.pos_arch);
            INORDEN(raiz^.sad);
        end;
    end;

    procedure PRE_ORDEN(raiz: PUNT_NODO);
    begin
        if raiz <> nil then
        begin
            Writeln('ID: ', raiz^.info.id, '  Pos: ', raiz^.info.pos_arch);
            PRE_ORDEN(raiz^.sai);
            PRE_ORDEN(raiz^.sad);
        end;
    end;
}

var ctx : T_CONTEXTO;
    
begin
    Clrscr;
    INIT_CTX(ctx);
    MenuPrincipal(ctx);
    
    //INORDEN(ctx.alumnos.nombre);
end.

