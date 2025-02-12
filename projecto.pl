% lp24 - ist1114018 - projecto 
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: nao deves copiar nunca os puzzles para o teu ficheiro de código
% Nao remover nem modificar as linhas anteriores. Obrigado.
% Segue-se o código
%%%%%%%%%%%%

% mesmoObj(X,Y) é verdade caso X e Y representarem o mesmo objeto (Estrela, Ponto ou Variável).
mesmoObj(X,Y):-
    X==Y; (var(X),var(Y)).

/*visualiza(Lista) é verdade se Lista é uma lista e a aplicação deste predicado permite
escrever, por linha, cada elemento da lista Lista.*/
visualiza([]).
visualiza([Elem|Resto]):-
    writeln(Elem),
    visualiza(Resto).

/*visualizaLinha(Lista) é verdade se Lista é uma lista e a aplicação deste predicado permite 
escrever, por linha, cada elemento da lista Lista, aparecendo antes o número da linha
em causa, um “:” e um espaço.*/
visualizaLinha(Lista):-
    visualizaLinha(Lista,1).
visualizaLinha([],_):-!.
visualizaLinha([Elem|Resto],Ac):-
    write(Ac), write(': '), writeln(Elem),
    Ac1 is Ac + 1,
    visualizaLinha(Resto,Ac1).

/*insereObjecto((L, C), Tabuleiro, Obj) é verdade se Tabuleiro é um tabuleiro que após
a aplicação deste predicado passa a ter o objecto Obj nas coordenadas (L,C), caso nestas
se encontre uma variável.*/
insereObjecto((L, C), Tabuleiro, Obj):-
    nth1(L,Tabuleiro,Linha),
    nth1(C,Linha,Elem),
    var(Elem),
    Elem = Obj,!.
insereObjecto(_,_,_):-!.

/*insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs) é verdade se ListaCoords
for uma lista de coordenadas, ListaObjs uma lista de objectos e Tabuleiro um tabuleiro que,
após a aplicação do predicado, passa a ter nas coordenadas de ListaCoords os objectos de
ListaObjs.*/
insereVariosObjectos([], _, []):-!.
insereVariosObjectos([Coordenada|Resto1], Tabuleiro, [Elem|Resto2]):-
    insereObjecto(Coordenada,Tabuleiro,Elem),
    insereVariosObjectos(Resto1,Tabuleiro,Resto2).

/*ListaMesmoObj(ListaCoord,Obj,ListaObj) é verdade se ListaCoord for uma lista de coordenada e
Obj for um objeto (estrela, ponto ou variável) e que, após a aplicação do predicado, cria ListaObj,
uma lista com mesmo tamanho de ListaCoord, composta por elemento iguais a Obj.*/
listaMesmoObj(ListaCoord,Obj,ListaObj):-
    length(ListaCoord,Tamanho),
    length(ListaObj, Tamanho),
    maplist(=(Obj), ListaObj).

/*inserePontosVolta(Tabuleiro, (L, C)) é verdade se Tabuleiro é um tabuleiro que, após
a aplicação do predicado, passa a ter pontos (p) à volta das coordenadas (L, C) (cima, baixo,
esquerda, direita e diagonais).*/
inserePontosVolta(Tabuleiro, (L, C)):-
    MaxL is L+1, MinL is L-1,
    MaxC is C+1, MinC is C-1,
    %Gera uma lista com todas as posições à volta possíveis
    findall((X,Y), 
        (between(MinL, MaxL, X),
        between(MinC,MaxC,Y),
        X > 0, Y > 0, 
        (X,Y)\==(L,C)),
        Elems),!,
    listaMesmoObj(Elems,p,ListaPontos),
    insereVariosObjectos(Elems,Tabuleiro,ListaPontos).

/*inserePontos(Tabuleiro, ListaCoord) é verdade se Tabuleiro é um tabuleiro que, após
a aplicação do predicado, passa a ter pontos (p) em todas as coordenadas de ListaCoord.*/
inserePontos(_,[]):-!.
inserePontos(Tabuleiro, [Coordenada|Resto]):-
    insereObjecto(Coordenada,Tabuleiro,p),
    inserePontos(Tabuleiro,Resto).

/*objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs) é verdade se ListaObjs
for a lista de objectos (pontos, estrelas ou variáveis) das coordenadas ListaCoords 
no tabuleiro Tabuleiro, apresentados na mesma ordem das coordenadas.*/
objectosEmCoordenadas([],_,[]):-!.
objectosEmCoordenadas([Coordenada|RestoCoor], Tabuleiro, [Elem|RestoElem]):-
    Coordenada = (L,C),
    nth1(L,Tabuleiro,Linha),
    nth1(C,Linha,Elem),
    objectosEmCoordenadas(RestoCoor,Tabuleiro,RestoElem).
   
/*coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos) é
verdade se Tabuleiro for um tabuleiro, Listacoords uma lista de coordenadas,
ListaCoordObjs a sublista de ListaCoords que contém as coordenadas dos objectos do tipo
Objecto, tal como ocorrem no tabuleiro e NumObjectos é o número de objectos Objecto encontrados.*/
coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos):-
    include(verificaObj(Tabuleiro, Objecto), ListaCoords, ListaCoordObjDesord),
    sort(ListaCoordObjDesord, ListaCoordObjs),
    length(ListaCoordObjs, NumObjectos).

/*verificaObj(Tabuleiro, Objecto, Coord) é verdade se Tabuleiro for um tabuleiro,
Objeto for um objeto (estrela, ponto ou variável), Coord for uma coordenada do tabuleiro e
o objeto que está em Coord for igual a Objeto.*/
verificaObj(Tabuleiro, Objecto, Coord):-
    objectosEmCoordenadas([Coord], Tabuleiro, [Obj]),
    mesmoObj(Objecto, Obj).

/*coordenadasVars(Tabuleiro, ListaVars) é verdade se ListaVars forem as coordenadas
das variáveis do tabuleiro Tabuleiro.*/
coordenadasVars(Tabuleiro, ListaVar):-
    length(Tabuleiro,Tamanho),
    %Gera uma lista com todas as coordenadas do tabuleiro
    findall((X,Y), 
        (between(1,Tamanho,X),
        between(1,Tamanho,Y)), 
        ElemLinha),
    coordObjectos(_,Tabuleiro,ElemLinha,ListaVar,_).

/*fechaListaCoordenadas(Tabuleiro, ListaCoord) que é verdade se Tabuleiro for um tabuleiro e 
ListaCoord for uma lista de coordenadas; após a aplicação deste predicado, as coordenadas de 
ListaCoord deverão ser apenas estrelas e pontos, que vão ser decididas aplicando as estrategias
especifica.*/
fechaListaCoordenadas(Tabuleiro, ListaCoord):-
    coordObjectos(e, Tabuleiro, ListaCoord, _, NumEstrela),
    coordObjectos(_, Tabuleiro, ListaCoord, ListaVar, NumVar),
    (NumEstrela =:= 2 -> inserePontos(Tabuleiro, ListaCoord);
     NumEstrela =:= 1, NumVar =:= 1 -> h2(Tabuleiro, ListaVar);
     NumEstrela =:= 0, NumVar =:= 2 -> h3(Tabuleiro, ListaVar);
     true).
/*h2(Tabuleiro, [Coord]) é verdade se Tabuleiro for um tabuleiro e [Coord] uma lista que contem uma
única coordenada, após a aplicação deste predicado, é inserido uma estrela na Coord e pontos à volta
desta.*/
h2(Tabuleiro,[Coord]):-
    inserePontosVolta(Tabuleiro,Coord), 
    insereObjecto(Coord,Tabuleiro,e).
/*h2(Tabuleiro, [Coord1,Coord2]) é verdade se Tabuleiro for um tabuleiro e [Coord1,Coord2] uma lista que 
contem duas coordenadas, após a aplicação deste predicado, é inserido uma estrela e pontos à volta
de cada uma das coordenadas (Coord1 e Coord2).*/
h3(Tabuleiro, [Coord1,Coord2]):-
    %Insere uma estrela e pontos à volta duas vezes
    h2(Tabuleiro,[Coord1]),
    h2(Tabuleiro,[Coord2]).

/*fecha(Tabuleiro, ListaListasCoord) que é verdade se Tabuleiro for um tabuleiro e
ListaListasCoord for uma lista de listas de coordenadas. Após a aplicação deste predicado,
Tabuleiro será o resultado de aplicar o predicado anterior a cada lista de coordenadas.*/
fecha(_,[]):-!.
fecha(Tabuleiro, [Area|Resto]):-
    fechaListaCoordenadas(Tabuleiro, Area),
    fecha(Tabuleiro, Resto).

/*encontraSequencia(Tabuleiro, N, ListaCoords, Seq) que é verdade se Tabuleiro for
um tabuleiro, ListaCoords for uma lista de coordenadas, N o tamanho de Seq, que é uma
sublista de ListaCoords e verifica se os objetos nas coordenadas de Seq são variáveis, 
as suas coordenadas aparecem seguidas e que Seq pode ser concatenada com duas listas,
uma antes e uma depois. */
encontraSequencia(Tabuleiro, N, ListaCoords, Seq):-
    coordObjectos(_, Tabuleiro, ListaCoords, ListaCoordObjs, N),
    coordObjectos(e, Tabuleiro, ListaCoords, _, 0),
    findall(X,(member(X,ListaCoords),member(X,ListaCoordObjs)),Seq),
    seguidas(ListaCoordObjs),          %ListaCoorObjs é Seq ordenada
    sublista(Seq,ListaCoords),!.

/*seguidas(ListaCoords) é verdade caso ListaCoords seja uma lista de coordenadas e verifica
se essas coordenadas estão em posições seguidas.*/
seguidas([_]):-!.
seguidas([(L1,C1),(L2,C2)|Resto]):-
    (L1 =:= L2 , abs(C1 - C2) =:= 1;       %Mesma Linha
    abs(L1 - L2) =:= 1, C1 =:= C2;         %Mesma Coluna
    abs(L1 - L2) =< 1, abs(C1 - C2) =< 1), %Mesma Regiao
    seguidas([(L2,C2)|Resto]).    

/*sublista(Seq,ListaCoords) é verdade caso Seq seja uma sublista de ListaCoords e ListaCoords
seja uma lista de coordenadas.*/
sublista(Seq,ListaCoords):-
    sublista(Seq, ListaCoords, 0).
sublista([],_,_):-!.
% No primeiro caso de seguida/3 encontra o index da primeira coord da Seq 
% na ListaCoords e guarda esse index
sublista([Primeiro|Resto], ListaCoords, 0):-
    nth1(Index,ListaCoords,Primeiro),
    sublista(Resto, ListaCoords, Index). 
% Garante que as restantes coords da Seq estão de seguida na ListaCoord
sublista([Primeiro|Resto], ListaCoords, Ac):-
    nth1(Index,ListaCoords,Primeiro),
    Index =:= Ac + 1,
    sublista(Resto, ListaCoords, Index).

/*aplicaPadraoI(Tabuleiro, [(L1, C1), (L2, C2), (L3, C3)]), que é verdade se
Tabuleiro for um tabuleiro e [(L1, C1), (L2, C2), (L3, C3)] for uma lista de coordenadas. 
Após a aplicação deste predicado, Tabuleiro será o resultado de colocar uma estrela em (L1, C1) e (L3, C3)
 e pontos à volta de cada estrela*/
aplicaPadraoI(Tabuleiro, [(L1, C1), _, (L3, C3)]):-
    insereVariosObjectos([(L1, C1),(L3, C3)],Tabuleiro,[e,e]),
    inserePontosVolta(Tabuleiro, (L1, C1)),
    inserePontosVolta(Tabuleiro, (L3, C3)).

/*aplicaPadroes(Tabuleiro, ListaListaCoords) que é verdade se Tabuleiro for um tabuleiro,
ListaListaCoords for uma lista de listas com coordenadas; após a aplicação deste
predicado ter-se-ão encontrado sequências de tamanho 3 e aplicado o aplicaPadraoI/2, ou
então ter-se-ão encontrado sequências de tamanho 4 e aplicado o aplicaPadraoT/2.*/
aplicaPadroes(_,[]):-!.
aplicaPadroes(Tabuleiro, [ListaCoord|Resto]):-
    encontraSequencia(Tabuleiro,3,ListaCoord,Seq),
    aplicaPadraoI(Tabuleiro, Seq),
    aplicaPadroes(Tabuleiro, Resto),!.
aplicaPadroes(Tabuleiro, [ListaCoord|Resto]):-
    encontraSequencia(Tabuleiro,4,ListaCoord,Seq),
    aplicaPadraoT(Tabuleiro, Seq),
    aplicaPadroes(Tabuleiro, Resto),!.
aplicaPadroes(Tabuleiro, [_|Resto]):-
    aplicaPadroes(Tabuleiro,Resto),!.

/*resolve(Estruturas, Tabuleiro) é verdade se Estrutura for uma estrutura e Tabuleiro
for um tabuleiro que resulta de aplicar os predicados aplicaPadroes/2 e fecha/2 até já não
haver mais alterações nas variáveis do tabuleiro.*/
resolve(Estruturas, Tabuleiro):-
    coordTodas(Estruturas, CoordTodas),
    coordenadasVars(Tabuleiro,ListaVarAntes),
    length(ListaVarAntes,NumAntes),
    aplicaPadroes(Tabuleiro, CoordTodas),
    fecha(Tabuleiro, CoordTodas),
    coordenadasVars(Tabuleiro,ListaVarDepois),
    length(ListaVarDepois,NumDepois),
    (NumDepois =:= 0 -> ! ; NumAntes =:= NumDepois -> ! ;
    resolve(Estruturas,Tabuleiro)).




