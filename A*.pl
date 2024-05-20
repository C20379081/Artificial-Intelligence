% Include Maze Configuration
:- include('maze3.pl').

% Define moves
move((X, Y), (X, NY)) :- NY is Y + 1. % Up
move((X, Y), (X, NY)) :- NY is Y - 1. % Down
move((X, Y), (NX, Y)) :- NX is X + 1. % Right
move((X, Y), (NX, Y)) :- NX is X - 1. % Left

% Check if the move is valid
valid_move((X, Y)) :- 
    within_bounds(X, Y), 
    \+ wall(X, Y).

% bounds of the maze deifned in the maze file
within_bounds(X, Y) :-
    bounds(MaxX, MaxY),
    X >= 1, X =< MaxX,
    Y >= 1, Y =< MaxY.


% Heuristic: Manhattan Distance
manhattan_distance((X1, Y1), (X2, Y2), D) :-
    D is abs(X1 - X2) + abs(Y1 - Y2).


% Entry point for A* search
% Calculate the heuristic value from the Start to the Goal using Manhattan distance.

astar(Start, Goal, Path) :-
    manhattan_distance(Start, Goal, H),
    astar_search([(H, 0, [Start])], Goal, RevPath), 
    reverse(RevPath, Path).

% Priority queue managed with F score and Path
% astar_search proceses the paths in the queue in an order based on their F score.
% When the Goal is found return the path as the solution.

astar_search([(_, _, [Goal|Rest])|_], Goal, [Goal|Rest]).
astar_search([(F, G, [Current|Rest])|Queue], Goal, Path) :-
    findall((NewF, NewG, [Next, Current|Rest]),
            ( move(Current, Next),
              valid_move(Next),
              \+ member(Next, [Current|Rest]),
              G1 is G + 1,
              manhattan_distance(Next, Goal, H),
              NewG is G1,
              NewF is NewG + H),
            NewPaths),
    append(Queue, NewPaths, NewQueue),
    sort(1, @=<, NewQueue, SortedQueue), 
    astar_search(SortedQueue, Goal, Path).

% Start solving the maze with A*
solve_maze(Start, Goal, Path) :-
    astar(Start, Goal, Path).

% Print moves 
print_moves([]).
print_moves([(X,Y)|T]) :-
    format('(~d,~d) ', [X, Y]),
    print_moves(T).

main :-
    Start = (5,6),
    Goal = (10,7),
    solve_maze(Start, Goal, Path),
    print_moves(Path),
    nl.

:- main.
