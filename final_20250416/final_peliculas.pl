:-dynamic(persona/5).

abrir:- retractall(pelicula(_,_,_,_,_)),
        consult('./bd_peliculas.txt').

menu:-abrir,
      writeln('1 - Ingresar edad e id y devolver una lista con nombres
      de las personas mayores a dicha edad que la vieron'),
      writeln('2 - Ingresar lista de dni y devolver listas de personas'),
      writeln('0 - Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:-writeln('Fin').

pertenece(X,[X|_]).
pertenece(X,[_|T]):-pertenece(X,T).

listar_personas(E, IdP, [H|T]):- persona(_,H,_,Edad,Peliculas),
                                 retract(persona(_,H,_,Edad,Peliculas)),
                                 Edad > E,
                                 pertenece(IdP, Peliculas),
                                 listar_personas(E,IdP,T).
listar_personas(_,_,[]).

leer([H|T]):- read(H), H\=[], leer(T).
leer([]).

contar([],0).
contar([_|T], Cant):- contar(T,CantAnt),
                      Cant is CantAnt + 1.

devolver_listas([],[],[]).
devolver_listas([H|T],[H|T1],LF):- persona(H,_,masculino,_,Peliculas),
                                   contar(Peliculas, Cant),
                                   Cant > 5,
                                   devolver_listas(T,T1,LF).
devolver_listas([H|T],LM,[H|T1]):- persona(H,_,femenino,_,Peliculas),
                                   contar(Peliculas, Cant),
                                   Cant > 5,
                                   devolver_listas(T,LM,T1).
devolver_listas([_|T],LM,LF):- devolver_listas(T,LM,LF).

opcion(1):- writeln('Ingresar edad: '), read(E),
            writeln('Ingresar id pelicula: '), read(IdP),
            listar_personas(E,IdP,Lista),
            writeln(Lista).

opcion(2):- writeln('Ingresar dnis: '),leer(Dnis),
            devolver_listas(Dnis,LM,LF),
            writeln(LM),
            writeln(LF).

opcion(_):- writeln('Opcion incorrecta').
