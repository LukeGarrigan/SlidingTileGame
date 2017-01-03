goal([2/2,1/3,2/3,3/3,3/2,3/1,2/1,1/1,1/2]).

% Empty can move to any of its neighbours which means that 'empty' and
% its neighbour interchange their positions

move( [Empty|L], [T|L1], 1):-              % All arc costs are 1
	swap(Empty, T, L, L1).             % Swap Empty and T in L giving L1

swap(Empty, T, [T|L], [Empty|L]):-
	d(Empty, T, 1).

swap(Empty, T, [T1|L],[T1|L1]):-
	swap(Empty, T, L, L1).


d(X/Y, X1/Y1, D):-
	dif(X, X1, Dx),
	dif(Y, Y1, Dy),
	D is Dx+Dy.

% Calucates the absolute difference
dif(A, B, D):-
	D is A-B,
	D >= 0, !;
	D is B-A.

% Heuristic estimate h is the sum of distances of each tile
% From its 'home' square pluis 3 times 'sequence' score
h([Empty|L], H):-
	goal([Empty|G]),
	totaldist(L, G, D),
	seq(L, S),
	H is D + 3*S.

% Calculates the entire distance of each head
totaldist([],[],0).
totaldist([T|L], [T1| L1], D):-
	d(T, T1, D1),
	totaldist(L,L1, D2),
	D is D1+D2.

seq([First|L], S):-
	seq([First|L],First,S).


seq([T1,T2|L],First, S):-
	score(T1,T2,S1),
	seq([T2|L], First, S2),
	S is S1 + S2.

seq([Last], First, S):-
	score(Last,First, S).

score( 2/2, _, 1):- !.

score( 1/3, 2/3, 0) :- !.
score( 2/3, 3/3, 0) :- !.
score( 3/3, 3/2, 0) :- !.
score( 3/2, 3/1, 0) :- !.
score( 3/l, 2/l, 0) :- !.
score( 2/l, 1/1, 0) :- !.
score( 1/l, l/2, 0) :- !.
score( 1/2, 1/3, 0) :- !.

score(_,_,2).


showsol([]).
showsol([P|L]):-
	showsol(L),
	nl, write('---'),
	showpos(P).

% Display a board position
showpos([S0, S1, S2, S3, S4, S5, S6, S7, S8]):-
	member(Y, [3,2,1]),
	nl, member(X, [1,2,3]),
	member(Tile-X/Y,
	       [''-S0,1-S1, 2-S2, 3-S3, 4-S4, 5-S5, 6-S6,7-S7, 8-S8]),
	write(Tile),fail.


showpos(_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%     A* Algorithm
%%%
%%%
%%%     Nodes have form    S#D#F#A
%%%            where S describes the state or configuration
%%%                  D is the depth of the node
%%%                  F is the evaluation function value
%%%                  A is the ancestor list for the node

:- op(400,yfx,'#').    /* Node builder notation */

solve(State,Soln) :- f_function(State,0,F),
                     search([State#0#F#[]],S), reverse(S,Soln).

f_function(State,D,F) :-
	h(State,H),
        F is D + H.

search([State#_#_#Soln|_], Soln) :- goal(State).
search([B|R],S) :- expand(B,Children),
                   insert_all(Children,R,Open),
                   search(Open,S).

insert_all([F|R],Open1,Open3) :- insert(F,Open1,Open2),
                                 insert_all(R,Open2,Open3).
insert_all([],Open,Open).

insert(B,Open,Open) :- repeat_node(B,Open), ! .
insert(B,[C|R],[B,C|R]) :- cheaper(B,C), ! .
insert(B,[B1|R],[B1|S]) :- insert(B,R,S), !.
insert(B,[],[B]).

repeat_node(P#_#_#_, [P#_#_#_|_]).

cheaper( _#_#F1#_ , _#_#F2#_ ) :- F1 < F2.

expand(State#D#_#S,All_My_Children) :-
     bagof(Child#D1#F#[Move|S],
           (D1 is D+1,
             move(State,Child,Move),
             f_function(Child,D1,F)),
           All_My_Children).














% dfs on this

:- dynamic(seennode/1).

depthfirst2(Node, [Node], _):-
	goal(Node).

depthfirst2(Node, _, Maxdepth):-
        Maxdepth > 0,
	seennode(Node), !,
	fail.

depthfirst2(Node, [Node|Solution], Maxdepth):-
	Maxdepth > 0,
	move(Node, Node1, 1),
	Max1 is Maxdepth -1,
	assertretract(seennode(Node)),
	depthfirst2(Node1, Solution, Max1).



assertretract(X) :- assert(X).
assertretract(X) :- retract(X), fail.



clear :-
	retractall(seenstate(_)).



















% Doesn't work, plus not got a scooby how it would work
% Best-first implementation
biggest(1000000).

bestfirst(Start, Solution):-
	biggest(Big),    % Big > any f-value
	expand([], l(Start, 0/0), Big,_,yes, Solution).


expand(P, l(N,_),_,_,yes,[N|P]):-
	goal(N).

expand(P, l(N,F/G), Bound, Tree1, Solved, Sol):-
	F =< Bound,
	(   bagof(M/C,(move(N,M,C),not(member(M,P))), Succ),!,
		  succlist(G, Succ, Ts),
		  bestf(Ts,F1),
		  expand(P, t(N,F1/G,Ts), Bound, Tree1, Solved, Sol);
		  solved = never).

expand(P, t(N, F/G,[T|Ts]), Bound, Tree1, Solved, Sol):-
	F =< Bound,
	bestf(Ts, BF), min(Bound, BF, Bound1),
	expand([N|P], T, Bound1, T1, Solved1, Sol),
	continue(P, t(N, F/G, [T1| Ts]), Bound, Tree1, Solved1, Solved, Sol).

expand(_,t(_,_,[]),_,_,never,_):-!.
expand(_,Tree,Bound,Tree,no,_):-
	f(Tree,F),F>Bound.

continue(_,_,_,_,yes,yes,Sol).
continue(P,t(N,F/G,[T1|Ts]), Bound,Tree1,Solved1, Solved,Sol):-
	(   Solved1 = no, insert(T1, Ts, NTs);
	Solved1 = never, NTs = Ts),
	bestf(NTs, F1),
	expand(P, t(N,F1/G,NTs), Bound, Tree1, Solved, Sol).

succlist(_,[],[]).
succlist(G0, [N/C|NCs], Ts):-
	G is G0 + C,
	h(N,H),
	F is G + H,
	succlist(G0, NCs, Ts1),
	insert(l(N,F/G), Ts1, Ts).


insert(T, Ts,[T|Ts]):-
	f(T,F), bestf(Ts,F1),
	F =< F1, !.
insert(T,[T1|Ts], [T1|Ts1]):-
	insert(T, Ts, Ts1).


f(l(_,F/_),F).
f(t(_,F/_,_),F).
bestf([T|_],F):-
	f(T,F).

bestf([],Big):-
	biggest(Big).
min(X, Y, X):-
	X =< Y, !.

min(X, Y, Y).

