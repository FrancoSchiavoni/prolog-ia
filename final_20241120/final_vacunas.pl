:-dynamic(persona/4).
:-dynamic(vacunas_por_edad/2).

abrir:-retractall(persona(_,_,_,_)),retractall(vacunas_por_edad(_,_)),
       consult('./bd_vacunas.txt').

menu:-abrir,
      writeln('1 - Dado un id persona y una edad, listar todas las vacunas que le corresponden a esa persona por su edad pero que aun no se aplico'),
      writeln('2 - Dada una edad y un idVacuna, contar cuantas veces esa vacuna fue aplicada en personas menores de eda edad'),
      read(Opc),Opc\=0,opcion(Opc),menu.
menu:-wrinteln('Fin').

pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).

mostrar_na(_,[]).
mostrar_na(Aplicadas,[H|T]):- pertenece(H,Aplicadas),
                              mostrar_na(Aplicadas,T).
mostrar_na(Aplicadas,[H|T]):- write(H), writeln(': No aplicada'),
                              mostrar_na(Aplicadas,T).



listar_na(IdP,EdadPersona):- persona(IdP,_,EdadPersona,Aplicadas),
                   vacunas_por_edad(E,Vacunas),
                   retract(vacunas_por_edad(E,Vacunas)),
                   EdadPersona > E,
                   mostrar_na(Aplicadas,Vacunas),
                   listar_na(IdP,EdadPersona).
listar_na(_,_).

contar_aplicaciones(E,IdV,Cant):- persona(_,_,EdadPersona,Aplicadas),
                                  retract(persona(_,_,EdadPersona,Aplicadas)),
                                  pertenece(IdV,Aplicadas),
                                  EdadPersona < 18,
                                  contar_aplicaciones(E,IdV,CantAnt),
                                  Cant is CantAnt + 1.
contar_aplicaciones(_,_,0).

opcion(1):- writeln('Ingrese id: '),read(IdP),writeln('Ingrese edad: '),read(EdadPersona), listar_na(IdP,EdadPersona).


opcion(2):- writeln('Ingrese edad: '), read(E), writeln('Ingrese id Vacuna: '),read(IdV),
            contar_aplicaciones(E,IdV,Cant),writeln(Cant).
