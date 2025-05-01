%artista(idArtista,nombre,otros_datos)
%cancion(idCancion,IdArtista,fecha_lanzamiento, otros_datos)
%usuario(idUsuario,nombre,otros_datos,[Lista_canciones_que_le_gustan])
%listaReproduccion(IdLista,IdUsuario,otros_datos,[Lista_Canciones])

:-dynamic(artista/3).
:-dynamic(cancion/4).
:-dynamic(usuario/4).
:-dynamic(listaReproduccion/4).

abrir:- retractall(artista(_,_,_)),
        retractall(cancion(_,_,_,_)),
        retractall(usuario(_,_,_,_)),
        retractall(listaReproduccion(_,_,_,_)),
        consult('./bd_musica.txt').

menu:-abrir,
      writeln('1 - Listar artista que lanzaron musica por anio'),
      writeln('2 - Mostrar por cada usuario cantidad de lista y promedio de canciones'),
      writeln('0 - Salir'),
      read(Opc),
      Opc\=0,
      opcion(Opc),
      menu.
menu:-writeln('Fin').

inicio:-menu.

%Ejercicio 1
listar_artistas(Anio, [H|T]):- cancion(_,IdArtista,Fecha,_),
                               sub_atom(Fecha,_,_,_,Anio),
                               artista(IdArtista, H, _),
                               retractall(cancion(_,IdArtista,_,_)),
                               listar_artistas(Anio,T).
listar_artistas(_, []).



%Ejercicio 2

contar(0,[]).
contar(Cant,[_|T]):- contar(CantAnt, T),
                     Cant is CantAnt + 1.

contar_canciones(IdUsuario, CantListas, TotalCanciones):- listaReproduccion(IdLista,IdUsuario,_,Canciones),
                                                          retract(listaReproduccion(IdLista,IdUsuario,_,Canciones)),
                                                          contar(CantCanciones,Canciones),
                                                          contar_canciones(IdUsuario, CantListasAnt, TotalCancionesAnt),
                                                          CantListas is CantListasAnt + 1,
                                                          TotalCanciones is TotalCancionesAnt + CantCanciones.
contar_canciones(_,0,0).


opcion(1):- writeln('Ingrese anio: '),read(Anio),
            listar_artistas(Anio,Lista),
            writeln(Lista).

opcion(2):- usuario(IdUsuario,Nombre,_,_),
            retract(usuario(IdUsuario,Nombre,_,_)),
            contar_canciones(IdUsuario,CantListas,TotalCanciones),
            CantListas\=0,
            Promedio is TotalCanciones/CantListas,
            writeln('--------'),
            write('La cantidad de listas para el usuario '),
            write(Nombre),write(' :'), writeln(CantListas),
            write('El promedio de canciones por lista: '), writeln(Promedio),
            opcion(2).
opcion(2).
