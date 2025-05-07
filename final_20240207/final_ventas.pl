:-dynamic(producto/4).
:-dynamic(producto_venta/3).

abrir:- retractall(producto(_,_,_,_)),
        retractall(producto_venta(_,_,_)),
        consult('./bd_ventas.txt').

menu:- abrir,
       writeln('1 - Mostrar precio promedio de producto por año-mes'),
       writeln('2 - Deteminar si todos tienen stock'),
       writeln('3 - Deteminar si todos tienen stock'),
       writeln('0 - Salir'),
       read(Opc),
       Opc\=0,
       opcion(Opc),
       menu.
menu:-writeln('Fin programa').

inicio:-menu.

sumar_cantidades(Desc,P,Cantidad,Total):- producto(IdProducto,Desc,_,_),
                                          producto_venta(IdProducto,Fecha,Precio),
                                          retract(producto_venta(IdProducto,Fecha,Precio)),
                                          sub_atom(Fecha,_,_,_,P),
                                          sumar_cantidades(Desc,P,CantAnt,TotalAnt),
                                          Cantidad is CantAnt + 1,
                                          Total is TotalAnt + Precio.
sumar_cantidades(_,_,0,0).


leer([H|T]):- read(H), H\=[], leer(T).
leer([]).


determinar_stock([],0).
determinar_stock([H|T],Contador):- producto(_,H,_,Stock),
                                   Stock = 0,
                                   determinar_stock(T,ContAnt),
                                   Contador is ContAnt + 1.
determinar_stock([_|T],Contador):- determinar_stock(T,Contador).


verificar_stock([]):- writeln('Todos tienen stock').
verificar_stock([H|T]):-producto(_,H,_,Stock),
                        Stock > 0,
                        verificar_stock(T).
verificar_stock(_):- writeln('No todos tienen stock').


opcion(1):- writeln('Ingrese descripcion producto: '),read(Desc),
            writeln('Ingrese año mes: '),read(P),
            sumar_cantidades(Desc,P,Cantidad,Total),
            Cantidad\=0,
            Prom is Total/Cantidad,
            writeln(Prom).

opcion(2):- writeln('Ingrese lista de descripciones: '),leer(Desc),
            determinar_stock(Desc, Contador),
            Contador\=0,
            writeln('NO Todos tienen stock').

opcion(2):-writeln('Todos tienen stock').


opcion(3):-writeln('Ingrese lista de descripciones: '),leer(Desc),
           verificar_stock(Desc).
