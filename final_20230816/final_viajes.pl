:-dynamic(unidades/3).
:-dynamic(viajes/2).

abrir:- retractall(unidades(_,_,_)),
        retractall(viajes(_,_)),
        consult('./bd_viajes.txt').

menu:-abrir,
      writeln('1 - Total de viajes por unidad: '),
      writeln('2 - Lista viajes mayor a 5000 '),
      writeln('0 - Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:-writeln('Fin programa').

inicio:-menu.


%Ejercicio 1

calcular_viajes(NroUnidad,Cant):- viajes(NroUnidad,Costo),
                                  retract(viajes(NroUnidad,Costo)),
                                  calcular_viajes(NroUnidad, CostoAnt),
                                  Cant is CostoAnt + Costo.
calcular_viajes(_,0).


% Ejercicio 2

leer([H|T]):-read(H), H\=[], leer(T).
leer([]).

listar_unidades([]).
listar_unidades([H|T]):- viajes(H,Costo),
                         Costo > 5000,
                         writeln(H),
                         listar_unidades(T).
listar_unidades([_|T]):- listar_unidades(T).



opcion(1):- unidades(NroUnidad,_,_),
            retract(unidades(NroUnidad,_,_)),
            calcular_viajes(NroUnidad,Cant),
            write('El total de viajes de unidad: '),write(NroUnidad),write(' es de: '),writeln(Cant),
            opcion(1).
opcion(1).

opcion(2):- writeln('Ingrese lista de unidades: '), leer(Unidades),
            listar_unidades(Unidades).
