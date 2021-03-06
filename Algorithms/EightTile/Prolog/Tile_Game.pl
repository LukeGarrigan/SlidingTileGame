:- module(tile_game, [goal/1, move/3, swap/5, mandist/4]).



goal([3/1, 1/3, 2/3, 3/3, 1/2, 2/2, 3/2, 1/1, 2/1]).
% Empty can move to any of its neighbours which means that 'empty' and
% its neighbour interchange their positions

% 0 is always at the head of the list so swaps are made there
move([Blank|Tiles], [Tile|New_Tiles], Direction):-              % All arc costs are 1
	swap(Blank, Tile, Tiles, New_Tiles, Direction).             % Swap Empty and T in L giving L1


swap(Blank, Tile, [Tile|Tiles], [Blank|Tiles], Direction):-  % T|L is the rest of the board
	mandist(Blank, Tile, 1, Direction).
	            % Finds all the possible legal moves
				   % The maximum difference must be one ( can't skip a tile )

swap(Blank, Tile, [First_Tile|Tiles],[First_Tile|New_Tiles], Direction):-
	swap(Blank, Tile, Tiles, New_Tiles, Direction ). % takes off the head of the tail and passe

mandist(X/Y,XD/Y,D,right) :-
    XD is X+D,
    XD < 4.
mandist(X/Y,X/YD,D,up) :-
    YD is Y+D,
    YD < 4.
mandist(X/Y,XD/Y,D,left) :-
    XD is X-D,
    XD > 0.
mandist(X/Y,X/YD,D,down) :-
    YD is Y-D,
    YD > 0.
