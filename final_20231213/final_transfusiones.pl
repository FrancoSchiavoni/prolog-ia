:-dynamic(receptor/3).
:-dynamic(donante/3).
:-dynamic(transfusion/4).

abrir:- retractall(receptor(_,_,_)),
        retractall(donante(_,_,_)),
        retractall(transfusion(_,_,_,_)),
        consult('./bd_donantes.txt').
menu:- abrir,
       writeln('1 - Mostrar cantidad de transfusiones por anio-mes y promedio de dondantes por transfusion'),
       writeln('2 - Listar receptores segun donante'),
       writeln('0 - Salir'),
       read(Opc),
       Opc\=0,
       opcion(Opc),
       menu.
menu:- writeln('Fin programa').

inicio:-menu.

% Ejercicio 1
contar_donantes([],0).
contar_donantes([_|T], TotalDonantes):- contar_donantes(T, TotalAnt),
                                        TotalDonantes is TotalAnt + 1.

calcular_t(P,Cantidad, Total):- transfusion(_,_,Fecha,Donantes),
                              retract(transfusion(_,_,Fecha,Donantes)),
                              sub_atom(Fecha,_,_,_,P),
                              contar_donantes(Donantes, TotalDonantes),
                              calcular_t(P, CantAnt, TotalAnt),
                              Cantidad is CantAnt + 1,
                              Total is TotalAnt + TotalDonantes.
calcular_t(_,0,0).


% Ejercicio 2
pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).


listar_receptores(DniD, [H|T]):- donante(IdD , DniD,_),
                                 transfusion(_,IdRecep,_,DonantesT),
                                 %retract(transfusion(_,IdRecep,_,DonantesT)), CREO Q NO SIRVE
                                 pertenece(IdD, DonantesT),
                                 receptor(IdRecep,H,_),
                                 retractall(transfusion(_,IdRecep,_,_)),
                                 listar_receptores(DniD,T).
listar_receptores(_,[]).



opcion(1):- writeln('Ingresar año-mes: '), read(P), calcular_t(P,Cantidad,Total),
            Cantidad\= 0,
            Prom is Total/Cantidad,
            writeln('Cantidad de transfusiones: '), writeln(Cantidad),
            writeln('Promedio de donantes: '), writeln(Prom).

opcion(2):- writeln('Ingresar DNI donante: '), read(DniD),
            listar_receptores(DniD, Receptores),
            writeln(Receptores).
