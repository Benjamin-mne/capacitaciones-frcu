unit AVL;

interface 
    type 
        T_DATO = record
            id: string;
            pos_arch: integer; 
        end;

        PUNT_NODO = ^NODO;

        NODO = record
            info: T_DATO; 
            sai: PUNT_NODO;
            sad: PUNT_NODO; 
            altura: integer;
        end;

        function ALTURA(N: PUNT_NODO): integer; // Función para obtener altura del arbol
        function CREAR_NODO(X: T_DATO): PUNT_NODO;  // Función para crear nodo
        function ROTACION_DERECHA(RAIZ: PUNT_NODO): PUNT_NODO; // Función para rotar a la derecha un subárbol dada una raiz
        function ROTACION_IZQUIERDA(RAIZ: PUNT_NODO): PUNT_NODO; // Función para rotar a la izquierda un subárbol dada una raiz
        function OBTENER_BALANCE(N: PUNT_NODO): integer; // Función para obteber el balance de un nodo dado
        function INSERTAR(N: PUNT_NODO; X: T_DATO): PUNT_NODO; // Función recursiva para insertar info en el subárbol con raíz en el nodo y devuelve la nueva raíz del subárbol.
        function MINIMO(N: PUNT_NODO): PUNT_NODO; // Función que devuelve el nodo con el id mínimo encontrado
        function ELIMINAR(N: PUNT_NODO; X: T_DATO): PUNT_NODO; // Función recursiva para eliminar un nodo dada la info en un subárbol con la raíz dada y devuelve la raíz del subárbol modificado.
        function BUSCAR(N: PUNT_NODO; id: string): PUNT_NODO; // Función para buscar nodo por id, retorna nil si no existe
        function ES_MENOR(a, b: string): boolean;
        function ES_MAYOR(a, b: string): boolean;

implementation
        uses Math, SysUtils;

        function ES_MENOR(a, b: string): boolean;
        var
            ai, bi: longint;
        begin
            if TryStrToInt(a, ai) and TryStrToInt(b, bi) then
                ES_MENOR := ai < bi
            else
                ES_MENOR := a < b;
        end;

        function ES_MAYOR(a, b: string): boolean;
        var
            ai, bi: longint;
        begin
            if TryStrToInt(a, ai) and TryStrToInt(b, bi) then
                ES_MAYOR := ai > bi
            else
                ES_MAYOR := a > b;
        end;

        function ALTURA(N: PUNT_NODO): integer;
        begin
            if (N = nil) then 
                Altura:= 0
            else 
                Altura:= N^.altura;
        end;

        function CREAR_NODO(X: T_DATO): PUNT_NODO;
        var nuevo_nodo: PUNT_NODO; 
        begin
            New(nuevo_nodo);
            nuevo_nodo^.info:= X;
            nuevo_nodo^.sai:= nil;
            nuevo_nodo^.sad:= nil;
            nuevo_nodo^.altura:= 1;

            CREAR_NODO:= nuevo_nodo;
        end;

        function ROTACION_DERECHA(RAIZ: PUNT_NODO): PUNT_NODO;
        var nueva_raiz, nueva_raiz_sai : PUNT_NODO;
        begin
            nueva_raiz:= RAIZ^.sai;
            nueva_raiz_sai:= nueva_raiz^.sad;

            // Rotar
            nueva_raiz^.sad:= RAIZ;
            RAIZ^.sai:= nueva_raiz_sai;

            // Actualizar alturas
            RAIZ^.altura:= max(ALTURA(RAIZ^.sai), ALTURA(RAIZ^.sad)) + 1;
            nueva_raiz^.altura:= max(ALTURA(nueva_raiz^.sai), ALTURA(nueva_raiz^.sad)) + 1;

            ROTACION_DERECHA:= nueva_raiz;
        end;

        function ROTACION_IZQUIERDA(RAIZ: PUNT_NODO): PUNT_NODO;
        var nueva_raiz, nueva_raiz_sad : PUNT_NODO;
        begin
            nueva_raiz:= RAIZ^.sad;
            nueva_raiz_sad:= nueva_raiz^.sai;

            // Rotar
            nueva_raiz^.sai:= RAIZ;
            RAIZ^.sad := nueva_raiz_sad;

            // Actualizar alturas
            RAIZ^.altura:= max(ALTURA(RAIZ^.sai), ALTURA(RAIZ^.sad)) + 1;
            nueva_raiz^.altura:= max(ALTURA(nueva_raiz^.sai), ALTURA(nueva_raiz^.sad)) + 1;

            ROTACION_IZQUIERDA:= nueva_raiz;
        end;

        function OBTENER_BALANCE(N: PUNT_NODO): integer;
        begin
            if (N = nil) then 
                OBTENER_BALANCE:= 0
            else 
                OBTENER_BALANCE:= ALTURA(N^.sai) - ALTURA(N^.sad);
        end;

        function INSERTAR(N: PUNT_NODO; X: T_DATO): PUNT_NODO;
        var 
            balance: integer;
            res : PUNT_NODO;
        begin
            // 1. Insertar al igual que en un BST
            
            if (N = nil) then 
            begin
                N := CREAR_NODO(X);
                res:= N;
            end
            else if ES_MENOR(X.id, N^.info.id) then 
                N^.sai:= INSERTAR(N^.sai, X)
            else
                N^.sad:= INSERTAR(N^.sad, X);

            if (N <> nil) then 
            begin
                res:= N; // Por defecto la raíz resultante es el mismo N

                // 2. Actualizar la altura nodo ancestro
                N^.altura:= max(ALTURA(N^.sai), ALTURA(N^.sad)) + 1;

                // 3. Obtener el balance del nodo ancestro para comprobar si este nodo se ha desequilibrado
                balance:= OBTENER_BALANCE(N);

                { Si este nodo esta DESEQUILIBRADO, entonces hay 4 casos: }

                // Caso: Izquierda-Izquierda
                if (balance > 1) AND (N^.sai <> nil) AND ES_MENOR(X.id, N^.sai^.info.id) then 
                    res:= ROTACION_DERECHA(N);

                // Caso: Derecha-Derecha
                if (balance < -1) AND (N^.sad <> nil) AND ES_MAYOR(X.id, N^.sad^.info.id) then 
                    res:= ROTACION_IZQUIERDA(N);

                // Caso: Izquierda-Derecha
                if (balance > 1) AND (N^.sai <> nil) AND ES_MAYOR(X.id, N^.sai^.info.id) then 
                begin
                    N^.sai:= ROTACION_IZQUIERDA(N^.sai);
                    res:= ROTACION_DERECHA(N);
                end;

                // Caso: Derecha-Izquierda
                if (balance < -1) AND (N^.sad <> nil) AND ES_MENOR(X.id, N^.sad^.info.id) then 
                begin
                    N^.sad:= ROTACION_DERECHA(N^.sad);
                    res:= ROTACION_IZQUIERDA(N);
                end;
            end;
        
            INSERTAR:= res;
        end;

        function MINIMO(N: PUNT_NODO): PUNT_NODO;
        var actual : PUNT_NODO;
        begin
            actual:= N;

            while (actual^.sai <> nil) do 
                actual:= actual^.sai;

            MINIMO:= actual;            
        end;

        function ELIMINAR(N: PUNT_NODO; X: T_DATO): PUNT_NODO;
        var
            res, temp: PUNT_NODO;
            balance: integer;
        begin
            res:= N;

            // 1. Eliminar al igual que en un BST

            if (N <> nil) then
            begin
                if ES_MENOR(X.id, N^.info.id) then
                    N^.sai:= ELIMINAR(N^.sai, X)
                else if ES_MAYOR(X.id, N^.info.id) then
                    N^.sad:= ELIMINAR(N^.sad, X)
                else
                begin
                    // Nodo encontrado
                    if (N^.sai = nil) OR (N^.sad = nil) then
                    begin
                        // Caso: 0 o 1 hijo
                        if (N^.sai <> nil) then
                            temp:= N^.sai
                        else
                            temp:= N^.sad;

                        if (temp = nil) then
                        begin
                            // Caso: nodo hoja
                            temp:= N;
                            N:= nil;
                            Dispose(temp);
                            res:= N;
                        end
                        else
                        begin
                            // Caso: un hijo (reemplazo directo)
                            temp:= N;
                            N:= temp^.sai;
                            
                            if (N = nil) then 
                                N:= temp^.sad;
                            
                            Dispose(temp);
                            res:= N;
                        end;
                    end
                    else
                    begin
                        // Caso: 2 hijos → tomar sucesor (min del subárbol derecho)
                        temp:= MINIMO(N^.sad);
                        N^.info:= temp^.info;

                        N^.sad:= ELIMINAR(N^.sad, temp^.info);
                        res:= N;
                    end;
                end;

                if (N = nil) then
                begin
                    res:= N;
                end else 
                begin
                    // 2. Actualizar la altura nodo actual
                    N^.altura:= max(ALTURA(N^.sai), ALTURA(N^.sad)) + 1;

                    // 3. Obtener el balance del nodo para comprobar si este nodo se ha desequilibrado
                    balance:= OBTENER_BALANCE(N);

                    { Si este nodo esta DESEQUILIBRADO, entonces hay 4 casos }

                    // Caso: Izquierda-Izquierda
                    if (balance > 1) AND (OBTENER_BALANCE(N^.sai) >= 0) then
                        res:= ROTACION_DERECHA(N);

                    // Caso: Derecha-Derecha
                    if (balance < -1) AND (OBTENER_BALANCE(N^.sad) <= 0) then
                        res:= ROTACION_IZQUIERDA(N);

                    // Caso: Izquierda-Derecha
                    if (balance > 1) AND (OBTENER_BALANCE(N^.sai) < 0) then
                    begin
                        N^.sai := ROTACION_IZQUIERDA(N^.sai);
                        res:= ROTACION_DERECHA(N);
                    end;

                    // Caso: Derecha-Izquierda
                    if (balance < -1) AND (OBTENER_BALANCE(N^.sad) > 0) then
                    begin
                        N^.sad := ROTACION_DERECHA(N^.sad);
                        res:= ROTACION_IZQUIERDA(N);
                    end;
                end;
            end;

            ELIMINAR:= res;
        end;

        function BUSCAR(N: PUNT_NODO; id: string): PUNT_NODO;
        begin
            if (N = nil) then
                BUSCAR:= nil
            else if (id = N^.info.id) then
                BUSCAR:= N
            else if ES_MENOR(id, N^.info.id) then
                BUSCAR:= BUSCAR(N^.sai, id)
            else
                BUSCAR:= BUSCAR(N^.sad, id);
        end;
end.