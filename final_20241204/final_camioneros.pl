:-dynamic(camion/2).
:-dynamic(conductor/4).

abrir:-retractall(cambion(_,_)),
       retractall(conductor(_,_,_,_)),
       consult('./bd_camioneros.txt').

menu:-abrir,
      writeln('1 - Listar habilitados'),
      writeln('2 - Listar < 30 anios'),
      writeln('0 - Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:-writeln('Fin').

% Ejercicio 1

leer([H|T]):- read(H), H\=[], leer(T).
leer([]).

pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).

listar_conductores(_,[]).
listar_conductores(CodCamion, [H|T]):- conductor(H,Nombre,_,Camiones),
                                       pertenece(CodCamion,Camiones),
                                       writeln(Nombre),
                                       listar_conductores(CodCamion,T).
listar_conductores(CodCamion, [_|T]):- listar_conductores(CodCamion,T).

% Ejercio 2

listar_por_edad(CodCamion):- conductor(_,Nombre,Edad,Camiones),
                             retract(conductor(_,Nombre,Edad,Camiones)),
                             pertenece(CodCamion, Camiones),
                             Edad =< 30,
                             writeln(Nombre),
                             listar_por_edad(CodCamion).
listar_por_edad(_).



opcion(1):- writeln('Ingresar codigo camion: '), read(CodCamion),
            writeln('Ingresar lista de conductores: '), leer(Conductores),
            listar_conductores(CodCamion,Conductores).


opcion(2):- writeln('Ingresar codigo camion: '), read(CodCamion),
            listar_por_edad(CodCamion).

