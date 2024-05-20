% Inlcudes the selected maze to test the algorithm on 
:- include('maze3.pl').

% Define valid moves by checking if they are within bounds of the game and not a wall
valid_move(X, Y) :-
    within_bounds(X, Y),
    \+ wall(X, Y).

% sets the size of the map usig the bounds varibale in the maze file
within_bounds(X, Y) :-
    bounds(MaxX, MaxY),
    X >= 1, X =< MaxX,
    Y >= 1, Y =< MaxY.

% depth first search algoirhtm
% attempts to find a path from the current position (X, Y) to the Goal.
% It constructs a path by exploring moves in a depth first approach.
% Visited variable is a list of nodes that have been explored to prevent infinite looops.

dfs(Goal, Goal, _, [Goal]).

% Try to move Up (Y+1)
dfs((X,Y), Goal, Visited, [(X,Y)|Path]) :-
    Y1 is Y + 1,
    valid_move(X, Y1),
    \+ member((X,Y1), Visited),
    dfs((X,Y1), Goal, [(X,Y1)|Visited], Path).

% Try to move Down (Y-1) 
dfs((X,Y), Goal, Visited, [(X,Y)|Path]) :-
    Y1 is Y - 1,
    valid_move(X, Y1),
    \+ member((X,Y1), Visited),
    dfs((X,Y1), Goal, [(X,Y1)|Visited], Path).

% Try to move right (x+1) 
dfs((X,Y), Goal, Visited, [(X,Y)|Path]) :-
    X1 is X + 1,
    valid_move(X1, Y),
    \+ member((X1,Y), Visited),
    dfs((X1,Y), Goal, [(X1,Y)|Visited], Path).

% Try to move left (x-1)
dfs((X,Y), Goal, Visited, [(X,Y)|Path]) :-
    X1 is X - 1,
    valid_move(X1, Y),
    \+ member((X1,Y), Visited),
    dfs((X1,Y), Goal, [(X1,Y)|Visited], Path).


% this is the entry point to solve the maze using DFS
solve_maze(Start, Goal, Path) :-
    dfs(Start, Goal, [Start], Path).


% print the list of moves
print_moves([]).
print_moves([(X,Y)|T]) :-
    format('(~d,~d)', [X, Y]),
    print_moves(T).
    
main :-
    Start = (5,6),
    Goal = (10,7),
    solve_maze(Start, Goal, Path),
    print_moves(Path),
    nl.

:- main.
