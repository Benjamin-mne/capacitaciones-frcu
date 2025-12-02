program main; 

uses
    Contexto, Menu, 
    crt;

var ctx : T_CONTEXTO;
    
begin
    Clrscr;
    INIT_CTX(ctx);
    MenuPrincipal(ctx);
end.

