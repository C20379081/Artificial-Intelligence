% Inlcudes the selected maze to test the algorithm on 
:- include('maze3.pl').

% X defines the move from left to right , Y defines the move up and down.

move(X, Y, NX, NY) :- NX is X, NY is Y + 1. % move up
move(X, Y, NX, NY) :- NX is X, NY is Y - 1. % move down
move(X, Y, NX, NY) :- NX is X + 1, NY is Y. % move right
move(X, Y, NX, NY) :- NX is X - 1, NY is Y. % move left

% Define valid moves by checking if they are within bounds of the game and not a wall
valid_move(X, Y) :-
    within_bounds(X, Y),
    \+ wall(X, Y).

% sets the size of the map usig the bounds varibale in the maze file
within_bounds(X, Y) :-
    bounds(MaxX, MaxY),
    X >= 1, X =< MaxX,
    Y >= 1, Y =< MaxY.

% Depth-Limited Search
% dls_helper performs a depth first search up to a specified depth limit.

dls_helper(Goal, Goal, Visited, Visited, _).
dls_helper((X, Y), Goal, Visited, Path, Depth) :-
    Depth > 0,
    move(X, Y, NX, NY),
    valid_move(NX, NY),
    \+ member((NX, NY), Visited),

    % Decrease the depth limit for the next recursive call.
    NewDepth is Depth - 1,

    % Recursive call dls_helper
    dls_helper((NX, NY), Goal, [(NX, NY)|Visited], Path, NewDepth).

% Wrapper for Depth Limited Search
dls(Start, Goal, Path, Depth) :-
    dls_helper(Start, Goal, [Start], Path, Depth).

% Iterative Deepening Search
ids(Start, Goal, Path) :-
    ids_helper(Start, Goal, Path, 1).

% Try to find the Goal using depth limited search with the current Depth.
ids_helper(Start, Goal, Path, Depth) :-
    dls(Start, Goal, Path, Depth) ;
    % If the Goal wasnt found, increase the depth by 1.
    NewDepth is Depth + 1,
    % Recursive call
    ids_helper(Start, Goal, Path, NewDepth).


% this is the entry point to solve the maze using IDS
solve_maze(Start, Goal, Path) :-
    ids(Start, Goal, Path).

% Printing the list of moves
print_moves([]).
print_moves([(X,Y)|T]) :-
    format('(~d,~d)', [X, Y]), 
    print_moves(T).
    
% Main execution block to solve and display the path
main :-
    Start = (5,6),
    Goal = (10,7),
    solve_maze(Start, Goal, Path),
    print_moves(Path),
    nl.
:- main.
