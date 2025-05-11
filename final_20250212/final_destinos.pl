:-dynamic(destinosTuristicos/4).

abrir:- retractall(destinosTuristicos(_,_,_,_)), consult('./bd_destinos.txt').

menu:-abrir,
      writeln('1 - Mostrar destinos segun parametros'),
      writeln('2 - Mostrar destinos segun lista de parametros'),
      writeln('0 - Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:- writeln('Fin').

pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).

mostrar_destinos(C,A,MaxDis,[H|T]):- destinosTuristicos(H, Distancia, Actividades, Comidas),
                               retract(destinosTuristicos(H, Distancia, Actividades, Comidas)),
                               pertenece(A,Actividades),
                               pertenece(C,Comidas),
                               Distancia < MaxDis,
                               mostrar_destinos(C,A,MaxDis,T).
mostrar_destinos(_,_,_,[]).

leer([H|T]):- read(H), H\=[], leer(T).
leer([]).

todas_pertenecen([],_).
todas_pertenecen([H|T],Actividades):- pertenece(H,Actividades),
                                      todas_pertenecen(T,Actividades).

destinos_act(ListaAct, [H|T]):- destinosTuristicos(H,_,Actividades,_),
                               retract(destinosTuristicos(H,_,Actividades,_)),
                               todas_pertenecen(ListaAct, Actividades),
                               destinos_act(ListaAct, T).
destinos_act(_,[]).


opcion(1):- writeln('Ingrese comida: '),read(C),
            writeln('Ingrese actividad: '),read(A),
            writeln('Ingrese distancia max: '),read(MaxDis),
            mostrar_destinos(C,A,MaxDis,Destinos),
            Destinos\=[],
            writeln(Destinos).
opcion(1):- writeln('No se encontraron destinos').



opcion(2):- writeln('Ingrese lista de actividades: '), leer(ListaAct),
            destinos_act(ListaAct,Destinos),
            Destinos \= [],
            writeln(Destinos).
opcion(2):- writeln('No se encontraron destinos').
