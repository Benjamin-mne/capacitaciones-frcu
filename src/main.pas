program main; 

uses
    AVL, DAOAlumno, Menu, crt;
    
{
procedure PRE_ORDEN(raiz: PUNT_NODO);
begin
    if raiz <> nil then
    begin
        Writeln('ID: ', raiz^.info.id, '  Pos: ', raiz^.info.pos_arch);
        PRE_ORDEN(raiz^.sai);
        PRE_ORDEN(raiz^.sad);
    end;
end;

procedure INORDEN(raiz: PUNT_NODO);
begin
    if raiz <> nil then
    begin
        INORDEN(raiz^.sai);
        Writeln('ID: ', raiz^.info.id, '  Pos: ', raiz^.info.pos_arch);
        INORDEN(raiz^.sad);
    end;
end;
}

var 
    alumnos_avl: PUNT_NODO;
    
begin
    Clrscr;
    alumnos_avl:= nil;
    CargarAlumnosAVL(alumnos_avl);
    MenuPrincipal(alumnos_avl);
    //INORDEN(alumnos_avl);
end.

