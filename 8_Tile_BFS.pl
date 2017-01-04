
goal([3/1, 1/3, 2/3, 3/3, 1/2, 2/2, 3/2, 1/1, 2/1]).
% Empty can move to any of its neighbours which means that 'empty' and
% its neighbour interchange their positions

% 0 is always at the head of the list so swaps are made there
move( [Blank|Tiles], [Tile|New_Tiles]):-              % All arc costs are 1
	swap(Blank, Tile, Tiles, New_Tiles).             % Swap Empty and T in L giving L1


swap(Blank, Tile, [Tile|Tiles], [Blank|Tiles]):-          % T|L is the rest of the board
	mandist(Blank, Tile, 1).  % Finds all the possible legal moves
			 % The maximum difference must be one ( can't skip a tile )

swap(Blank, Tile, [First_Tile|Tiles],[First_Tile|New_Tiles]):-
	swap(Blank, Tile, Tiles, New_Tiles ). % takes off the head of the tail and passe

% D is the Manh. distance
mandist( X /Y , X1 / Y1 , D ):-
       D is abs(X - X1 )+ abs(Y - Y1 ).


solve( Start, Solution)  :-
  breadthfirst( [ [Start] ], Sal),
  reverse(Sal, Solution).

% This checks to see if the current configuration is the goal
breadthfirst( [ [Node | Path] | _], [Node | Path])  :-
  goal(Node).

% The reason for storing all the paths is to ensure that we do not
% choose the same path repeatedly

breadthfirst( [Path | Paths], Solution)  :-
  extend( Path, NewPaths),            % Finds all the possibilities that haven't been chosen
  conc( Paths, NewPaths, Paths1),     % Concatenates the paths
  breadthfirst( Paths1, Solution).    % Continues with the new paths

extend( [Node | Path], NewPaths) :-
  % Finds all the possibilities that we haven't already chosen
  bagof( [NewNode, Node | Path],
	  ( move( Node, NewNode), not(member( NewNode, [Node | Path]
	  )) ),
         NewPaths),
  !.

extend( _, [] ).              % bagof failed: Node has no successor


conc([],L,L).
conc([H|L1],L2,[H|L3]):-
     conc(L1,L2,L3).






















% solve( Start, Solution)  :-
%  breadthfirst( [ [Start] | Z] - Z, Solution).

%breadthfirst( [ [Node | Path] | _] - _, [Node | Path] )  :-
%  goal( Node).

%breadthfirst( [Path | Paths] - Z, Solution)  :-
%  extend( Path, NewPaths),
%  conc( NewPaths, Z1, Z),              % Add NewPaths at end
%  Paths \== Z1,                        % Set of candidates not empty
%  breadthfirst( Paths - Z1, Solution).

