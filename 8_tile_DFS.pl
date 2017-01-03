goal(1/2/3/4/5/6/7/8/0).

left( A/0/C/D/E/F/H/I/J , 0/A/C/D/E/F/H/I/J ).
left( A/B/C/D/0/F/H/I/J , A/B/C/0/D/F/H/I/J ).
left( A/B/C/D/E/F/H/0/J , A/B/C/D/E/F/0/H/J ).
left( A/B/0/D/E/F/H/I/J , A/0/B/D/E/F/H/I/J ).
left( A/B/C/D/E/0/H/I/J , A/B/C/D/0/E/H/I/J ).
left( A/B/C/D/E/F/H/I/0 , A/B/C/D/E/F/H/0/I ).

up( A/B/C/0/E/F/H/I/J , 0/B/C/A/E/F/H/I/J ).
up( A/B/C/D/0/F/H/I/J , A/0/C/D/B/F/H/I/J ).
up( A/B/C/D/E/0/H/I/J , A/B/0/D/E/C/H/I/J ).
up( A/B/C/D/E/F/0/I/J , A/B/C/0/E/F/D/I/J ).
up( A/B/C/D/E/F/H/0/J , A/B/C/D/0/F/H/E/J ).
up( A/B/C/D/E/F/H/I/0 , A/B/C/D/E/0/H/I/F ).

right( A/0/C/D/E/F/H/I/J , A/C/0/D/E/F/H/I/J ).
right( A/B/C/D/0/F/H/I/J , A/B/C/D/F/0/H/I/J ).
right( A/B/C/D/E/F/H/0/J , A/B/C/D/E/F/H/J/0 ).
right( 0/B/C/D/E/F/H/I/J , B/0/C/D/E/F/H/I/J ).
right( A/B/C/0/E/F/H/I/J , A/B/C/E/0/F/H/I/J ).
right( A/B/C/D/E/F/0/I/J , A/B/C/D/E/F/I/0/J ).

down( A/B/C/0/E/F/H/I/J , A/B/C/H/E/F/0/I/J ).
down( A/B/C/D/0/F/H/I/J , A/B/C/D/I/F/H/0/J ).
down( A/B/C/D/E/0/H/I/J , A/B/C/D/E/J/H/I/0 ).
down( 0/B/C/D/E/F/H/I/J , D/B/C/0/E/F/H/I/J ).
down( A/0/C/D/E/F/H/I/J , A/E/C/D/0/F/H/I/J ).
down( A/B/0/D/E/F/H/I/J , A/B/F/D/E/0/H/I/J ).

move(P,C,left) :-  left(P,C).
move(P,C,up) :-  up(P,C).
move(P,C,right) :-  right(P,C).
move(P,C,down) :-  down(P,C).





printlist([]).
printlist([X|Y]) :- write(X), nl, printlist(Y).

printindent( X, 0 ) :- write(X), nl, !.
printindent( X, N ) :- write('  '), M is N-1, printindent(X,M).

assertretract(X) :- assert(X).
assertretract(X) :- retract(X), fail.

% Lets give the books version of dfs a go

:- dynamic(seennode/1).

solve(Node, Solution):-
	depthfirst([],Node, Solution, 0).

depthfirst(Path,Node, [Node|Path], N):-
	N < 25,
	goal(Node),
	write('blar').

depthfirst(_,Node, _, N):-
	N < 25,
	seennode(Node), !,
	fail.


depthfirst(Path ,Node, Solution, N):-
	N < 25,
	move(Node, Node1, _), M is N + 1,
	assertretract(seennode(Node)),
	depthfirst([Node|Path], Node1, Solution, M).



% Use this one, this way you can alter the depth in the command line

depthfirst2(Node, [Node], _):-
	goal(Node).

depthfirst2(Node, _, Maxdepth):-
        Maxdepth > 0,
	seennode(Node), !,
	fail.

depthfirst2(Node, [Node|Solution], Maxdepth):-
	Maxdepth > 0,
	move(Node, Node1, _),
	Max1 is Maxdepth -1,
	assertretract(seennode(Node)),
	depthfirst2(Node1, Solution, Max1).










:- dynamic(seenstate/1).

solveall( S, _, N ) :-
    N<30,
    seenstate(S), !,
    printindent( alreadytried(S), N ),
    fail.

% If we're at the final state, succeed.
solveall( S, [S], N ) :-
    N<30,
    goal(S),
    printindent( goalfound(S), N ),
    writef( '%w moves.\n', [N] ).

% Otherwise, assert that we have seen the current state, then choose a
% successor state and solve it.
solveall( S, [S|Rest], N ) :-
    N<30,
   %printindent( solving(S), N ),
    assertretract( seenstate(S) ),
    move(S,T, _), M is N+1, solveall(T,Rest,M).


clear():-
	retractall(seennode(_)),
	retractall(seenstate(_)).







