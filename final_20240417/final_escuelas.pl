:-dynamic(escuela/3).
:-dynamic(alumno/4).

abrir:-retractall(escuela(_,_,_)),
       retractall(alumno(_,_,_,_)),
       consult('./bd_escuela.txt').

menu:-abrir,
      writeln('1- Mostrar promedio de altura por escuela: '),
      writeln('2- Mostrar lista de alumnos que midan menos 165cm'),
      writeln('0- Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:-writeln('Adios').

%Ejercicio 1
calcular_alturas(IdEscuela,Cant,Total):- alumno(_,IdEscuela,_,Altura),
                                         retract(alumno(_,IdEscuela,_,Altura)),
                                         calcular_alturas(IdEscuela,CantAnt,TotalAnt),
                                         Cant is CantAnt + 1,
                                         Total is TotalAnt + Altura.
calcular_alturas(_,0,0).

%Ejercicio 2

listar_alumnos(IdEscuela, [H|T]):- alumno(H,IdEscuela,_,Altura),
                                   retract(alumno(H,IdEscuela,_,Altura)),
                                   Altura < 165,
                                   listar_alumnos(IdEscuela, T).
listar_alumnos(_,[]).

opcion(1):- escuela(IdEscuela, Nombre,_),
            retract(escuela(IdEscuela, Nombre,_)),
            calcular_alturas(IdEscuela, Cant, Total),
            Prom is Total/Cant,
            write('Escuela: '), writeln(Nombre),
            write('El promedio de altura de los alumnos: '), writeln(Prom),
            opcion(1).
opcion(1).

opcion(2):- writeln('Ingresar IdEscuela: '), read(IdEscuela),
            listar_alumnos(IdEscuela, Alumnos),
            writeln(Alumnos).
