:- dynamic(comision/5).

abrir:- retractall(comision(_,_,_,_,_)),
        consult('./bd_comisiones.txt').

menu:-abrir,
      writeln('1 - Ingresar nro de comision y crear listas inscriptos y no inscriptos '),
      writeln('2 - Ingresar nro de comision y mostrar porcentaje de alumnos aprobados'),
      writeln('0 - Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:- writeln('Salir').
inicio:-menu.

% Ejercicio 1

leer([H|T]):- read(H), H\=[], leer(T).
leer([]).

pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).


listar_alumnos(_,[],[],[]).
listar_alumnos(C,[H|T],[H|T1],LN):-  comision(C,_,_,Legajos,_),
                                     pertenece(H,Legajos),
                                     listar_alumnos(C,T,T1,LN).
listar_alumnos(C,[H|T],LI,[H|T2]):-  listar_alumnos(C,T,LI,T2).

% Ejercicio 2

contar([],0,0).
contar([H|T], Total, TotalAprobados):- H>=6,
                                       contar(T,TotalAnt,TotalAprobAnt),
                                       Total is TotalAnt + 1,
                                       TotalAprobados is TotalAprobAnt + 1.
contar([_|T], Total, TotalAprobados):- contar(T,TotalAnt, TotalAprobados),
                                       Total is TotalAnt + 1.

opcion(1):- writeln('Ingrese comision: '), read(C),
            writeln('Ingrese lista de legajos: '), leer(Lista),
            listar_alumnos(C,Lista,LI,LN),
            writeln(LI),
            writeln(LN).

opcion(2):- writeln('Ingresar numero de comision: '), read(C),
            comision(C,_,_,_,Notas),
            contar(Notas,Total,Aprobados),
            Porcentaje is ((Aprobados/Total)*100),
            write(Porcentaje), writeln('%').
