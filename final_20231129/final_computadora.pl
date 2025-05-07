% computadora(id, tipo, precio, stock, [características])
% ventas(id, fecha, [idCompusVendidas]) % fecha es aaaa-mm-dd

:-dynamic(computadora/5).
:-dynamic(ventas/3).

abrir:- retractall(computadora(_,_,_,_,_)), retractall(ventas(_,_,_)),
        consult('./bd_compu.txt').

menu:- abrir,
       writeln('1 - Monto total recaudado por año-mes'),
       writeln('2 - Obtener lista de pc segun caracteristicas'),
       writeln('0 - Salir'),
       read(Opc),
       Opc\= 0,
       opcion(Opc),
       menu.
menu:- writeln('Fin programa').

inicio:- menu.

% Ejercicio 1
total_venta([],0).
total_venta([H|T], Total):- computadora(H,_,Precio,_,_),
                            total_venta(T,TotalAnt),
                            Total is TotalAnt + Precio.

calcular_monto(P,Monto):- ventas(_,Fecha,Computadoras),
                          retract(ventas(_,Fecha,Computadoras)),
                          sub_atom(Fecha,_,_,_,P),
                          total_venta(Computadoras, Total),
                          calcular_monto(P, MontoAnt),
                          Monto is MontoAnt + Total.
calcular_monto(_,0).

% Ejercicio 2

leer([H|T]):- read(H), H\=[], leer(T).
leer([]).


pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).

todas_pertenecen([],_).
todas_pertenecen([H|T], CaracteristicasPC):- pertenece(H,CaracteristicasPC),
                                             todas_pertenecen(T,CaracteristicasPC).


listar_pc(Caract, [H|T]):- computadora(H,_,_,_,CaracteristicasPC),
                           retract(computadora(H,_,_,_,CaracteristicasPC)),
                           todas_pertenecen(Caract, CaracteristicasPC),
                           listar_pc(Caract, T).
listar_pc(_,[]).

opcion(1):- writeln('Ingrese año-mes: '), read(P), calcular_monto(P,Monto), writeln(Monto).


opcion(2):- writeln('Ingrese lista de caracteristicas: '), leer(Caract), listar_pc(Caract, Computadoras), writeln(Computadoras).
