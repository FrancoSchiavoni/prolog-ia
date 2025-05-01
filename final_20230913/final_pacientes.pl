%paciente (dni, nombre,obra social)
%profesional(dni,nombre,especialidad,obra social)
%turno(dnipaciente,dniprofesional,especialidad,fecha,obra social,monto)

:-dynamic(paciente/3).
:-dynamic(profesional/4).
:-dynamic(turno/6).

abrir:-retractall(paciente(_,_,_)),
       retractall(profesional(_,_,_,_,_)),
       retractall(turno(_,_,_,_,_,_)),
       consult('./bd_pacientes.txt').

menu:-abrir,
      writeln('1 - Listar especialidades segun paciente y anio'),
      writeln('2 - Mostrar profesionales donde el monto del turno fue mayor a 1500'),
      writeln('0 - Salir'),
      read(Opc),
      opcion(Opc),
      menu.
menu:-writeln('Fin programa').

inicio:-menu.


listar_especialidades(Nombre, A):- paciente(Dni, Nombre,_),
                                   turno(Dni,_,Esp,Fecha,_,_),
                                   sub_atom(Fecha,_,_,_,A),
                                   writeln(Esp),
                                   retractall(turno(Dni,_,Esp,_,_,_)),
                                   listar_especialidades(Nombre,A).
listar_especialidades(_,_).


contar_turnos(Dni,Cantidad):- turno(_,Dni,_,_,_,Total),
                              retract(turno(_,Dni,_,_,_,Total)),
                              Total > 1500,
                              contar_turnos(Dni,CantAnt),
                              Cantidad is CantAnt + 1.
contar_turnos(_,0).

opcion(1):- writeln('Ingrese nombre paciente: '),read(Nombre),
            writeln('Ingrese año: '), read(A),
            listar_especialidades(Nombre, A).


opcion(2):- profesional(Dni, Nombre,_,_),
            retract(profesional(Dni, Nombre,_,_)),
            contar_turnos(Dni,Cantidad),
            write('La cantidad de turnos > 1500 del profesional: '), write(Nombre), write(' es de: '), writeln(Cantidad),
            opcion(2).
opcion(2).

opcion(_):- writeln('Opcion incorrecta').
