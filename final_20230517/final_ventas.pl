:-dynamic(venta/4).

abrir:- retractall(venta(_,_,_,_)),
        consult('./bd_ventas.txt').

menu:-abrir,
      writeln('1 - Consumo promedio anual de cliente'),
      writeln('2 - Clientes que compraron producto'),
      writeln('3 - Maximo consumo de persona'),
      writeln('4 - Minimo consumo de persona'),
      writeln('0 - Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:- writeln('Fin programa').

inicio:-menu.

% Ejercicio 1
consumo_promedio(Dni, Anio, Cant, Total):- venta(Dni,_,Fecha,Importe),
                                           retract(venta(Dni,_,Fecha,Importe)),
                                           sub_atom(Fecha,_,_,_,Anio),
                                           consumo_promedio(Dni,Anio,CantAnt,TotalAnt),
                                           Cant is CantAnt + 1,
                                           Total is TotalAnt + Importe.
consumo_promedio(_,_,0,0).

% Ejercicio 2
listado_dni(D,[H|T]):- venta(H, D, Fecha,_),
                       retract(venta(H, D,Fecha,_)),
                       sub_atom(Fecha,_,_,_,'2024'),
                       listado_dni(D,T).
listado_dni(_,[]).


%Ejercicio 3
maximo_consumo(Dni, Max):- venta(Dni,_,_,Monto),
                           retract(venta(Dni,_,_,Monto)),
                           maximo_consumo(Dni, MHM),
                           comparar(Max,MHM,Monto).
maximo_consumo(_,0).
comparar(Monto,MHM,Monto):- Monto >= MHM.
comparar(MHM,MHM,_).

minimo_consumo(Dni,Min):- venta(Dni,_,_,Monto),
                          retract(venta(Dni,_,_,Monto)),
                          minimo_consumo(Dni,MHM),
                          comparar_minimo(Monto,MHM,Min).
minimo_consumo(_,0).
comparar_minimo(Monto,MHM,Monto):- Monto =< MHM.
comparar_minimo(Monto,MHM,Monto):- MHM == 0.
comparar_minimo(_,MHM,MHM).



opcion(1):-  writeln('Ingrese Dni: '), read(Dni),
             venta(Dni,_,_,_),
             writeln('Ingrese un anio: '), read(Anio),
             consumo_promedio(Dni, Anio, Cant, Total),
             Cant\=0,
             Prom is Total/Cant,
             writeln('El consumo promedio es: '), writeln(Prom).
opcion(1):-  writeln('No se encuentra el dni o no tiene ventas').


opcion(2):- writeln('Ingrese descripcion: '), read(D),
            listado_dni(D, Listado),
            writeln(Listado).

opcion(3):- writeln('Ingrese dni: '), read(Dni),
            maximo_consumo(Dni, Max),
            write('El maximo consumo es: '), writeln(Max).

opcion(4):- writeln('Ingrese dni: '), read(Dni),
            minimo_consumo(Dni,Min),
            write('El minimo consumo es: '), writeln(Min).









