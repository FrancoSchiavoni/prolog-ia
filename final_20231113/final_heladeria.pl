:-dynamic(heladeria/3).
:-dynamic(locales/3).

abrir:- retractall(heladeria(_,_,_)),
        retractall(locales(_,_,_)),
        consult('./bd_heladeria.txt').
menu:- abrir,
       writeln('1 - Lista de heladerias en el centro'),
       writeln('2 - Lista de heladerias que se encuentran en una calle'),
       writeln('0 - Salir'),
       read(Opc),
       Opc\=0,
       opcion(Opc),
       menu.
menu:- writeln('Fin').
inicio:- menu.


% Ejercicio 1
leer([H|T]):- read(H), H\=[], leer(T).
leer([]).


listar_centro([Cod|T1], [H|T2]):-  locales(Cod, centro, _),
                                   heladeria(Cod,H,_),
                                   listar_heladerias(T1, T2).
listar_centro([_|T1], Filtradas):- listar_heladerias(T1, Filtradas).
listar_centro([],[]).


%Ejercicio 2

pertenece(Calle, [H|_]):- sub_atom(H,_,_,_,Calle).
pertenece(Calle, [_|T]):- pertenece(Calle, T).

listar_heladerias(Calle, [H|T]):- locales(Cod,_,Direcciones),
                                  pertenece(Calle, Direcciones),
                                  heladeria(Cod, H, _),
                                  retractall(locales(Cod,_,_)),
                                  listar_heladerias(Calle, T).
listar_heladerias(_,[]).

opcion(1):- writeln('Ingrese lista de heladerias: '), leer(Heladerias), listar_centro(Heladerias, Filtradas), writeln(Filtradas).


opcion(2):- writeln('Ingresar una calle: '), read(Calle), listar_heladerias(Calle, Heladerias), writeln(Heladerias).
