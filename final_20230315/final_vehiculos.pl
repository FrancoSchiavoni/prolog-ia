:-dynamic(vehiculos/6).
:-dynamic(caracteristicas/2).

abrir:- retractall(vehiculos),
        retractall(caracteristicas),
        consult('./bd_vehiculos.txt').

menu:- abrir,
       writeln('1 - Mostrar autos por filtros: '),
       writeln('2 - Contar cantidad de autos por filtros'),
       writeln('0 - Salir'),
       read(Opc),
       Opc\=0,
       opcion(Opc),
       menu.
menu:- writeln('Fin').

inicio:-menu.

% Ejercicio 1
leer([H|T]):- read(H),H\=[], leer(T).
leer([]).

pertenece(X, [X|_]).
pertenece(X, [_|T]):- pertenece(X,T).

todas_pertenecen([],_).
todas_pertenecen([H|T], ListaCaract):- caracteristicas(Id, H),
                                       pertenece(Id,ListaCaract),
                                       todas_pertenecen(T, ListaCaract).


mostrar_v(Max,Min,Caracteristicas):- vehiculos(Marca, Precio, Tipo, Estado, ListaCaract, Otros),
                                    retract(vehiculos(Marca, Precio, Tipo, Estado, ListaCaract, Otros)),
                                    Precio =< Max,
                                    Precio >= Min,
                                    todas_pertenecen(Caracteristicas, ListaCaract),
                                    writeln('-----'),
                                    writeln(Marca),
                                    writeln(Tipo),
                                    writeln(Estado),
                                    writeln(Otros),
                                    writeln(Precio),
                                    mostrar_v(Max,Min,Caracteristicas).
mostrar_v(_,_,_).

contar_autos(C,E,Cant):- caracteristicas(Cod, C),
                         vehiculos(_,_,_,E,Caracteristicas,_),
                         retract(vehiculos(_,_,_,E,Caracteristicas,_)),
                         pertenece(Cod,Caracteristicas),
                         contar_autos(C,E,CantAnt),
                         Cant is CantAnt + 1.
contar_autos(_,_,0).

opcion(1):- writeln('Ingrese precio max: '),read(Max),
            writeln('Ingrese precio min: '),read(Min),
            writeln('Ingrese lista de caracteristicas: '), leer(Caracteristicas),
            mostrar_v(Max,Min,Caracteristicas).

opcion(2):- writeln('Ingrese una caracteristica: '),read(C),
            writeln('Ingrese un estado: '), read(E),
            contar_autos(C,E,Cant),
            writeln('Cantidad de autos: '), writeln(Cant).

opcion(_):- writeln('Opcion invalida').

