% Define the target goal state.
goal([[1,2,3], [4,5,6], [7,8,0]]).

% Best First Search for the 8-puzzle problem.
solve_bfs(Start, Solution) :-
    bfs([[Start, [], 0]], [], Solution).

% BFS core function.
bfs([[State, Path, _]|_], _, Solution) :-
    goal(State),                        % If the current state is the goal, return the solution.
    reverse(Path, Solution).

bfs([[State, Path, _]|RestQueue], Visited, Solution) :-
    findall([NextState, [Move|Path], H],
            (move(State, NextState, Move),
             \+ member(NextState, Visited),
             heuristic(NextState, H)),
            NextMoves),
    append(RestQueue, NextMoves, UpdatedQueue),
    sort_queue(UpdatedQueue, SortedQueue),   % Sort the queue based on heuristic value.
    bfs(SortedQueue, [State|Visited], Solution).  % Recursively search for solution.

% Define possible moves (left, right, up, down).
move(State, NextState, left) :- move_left(State, NextState).
move(State, NextState, right) :- move_right(State, NextState).
move(State, NextState, up) :- move_up(State, NextState).
move(State, NextState, down) :- move_down(State, NextState).

% Move the blank tile left.
move_left(State, NextState) :-
    blank(State, X, Y),
    Y > 0,
    swap(State, X, Y, X, Y-1, NextState).

% Move the blank tile right.
move_right(State, NextState) :-
    blank(State, X, Y),
    Y < 2,
    swap(State, X, Y, X, Y+1, NextState).

% Move the blank tile up.
move_up(State, NextState) :-
    blank(State, X, Y),
    X > 0,
    swap(State, X, Y, X-1, Y, NextState).

% Move the blank tile down.
move_down(State, NextState) :-
    blank(State, X, Y),
    X < 2,
    swap(State, X, Y, X+1, Y, NextState).

% Find the position of the blank (0) tile.
blank(State, X, Y) :-
    nth0(X, State, Row),
    nth0(Y, Row, 0).

% Swap two tiles in the state.
swap(State, X1, Y1, X2, Y2, NextState) :-
    nth0(X1, State, Row1),
    nth0(Y1, Row1, Tile1),
    nth0(X2, State, Row2),
    nth0(Y2, Row2, Tile2),
    replace(Row1, Y1, Tile2, NewRow1),
    replace(Row2, Y2, Tile1, NewRow2),
    replace(State, X1, NewRow1, TempState),
    replace(TempState, X2, NewRow2, NextState).

% Helper function to replace an element in a list.
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]) :- I > 0, I1 is I - 1, replace(T, I1, X, R).

% Heuristic function: Manhattan distance.
heuristic(State, H) :-
    goal(GoalState),
    manhattan_distance(State, GoalState, H).

% Calculate Manhattan distance.
manhattan_distance([], [], 0).
manhattan_distance([Row1|Rest1], [Row2|Rest2], Distance) :-
    manhattan_distance_row(Row1, Row2, D),
    manhattan_distance(Rest1, Rest2, RestDistance),
    Distance is D + RestDistance.

% Calculate Manhattan distance for a single row.
manhattan_distance_row([], [], 0).
manhattan_distance_row([Tile1|Rest1], [Tile2|Rest2], Distance) :-
    (Tile1 = 0 -> D = 0; Tile1 \= Tile2 -> D = 1; D = 0),
    manhattan_distance_row(Rest1, Rest2, RestDistance),
    Distance is D + RestDistance.

% Sort the queue based on heuristic value (Best First strategy).
sort_queue(List, Sorted) :-
    sort(3, @=<, List, Sorted).



command 
?- solve_bfs([[2, 8, 3], [1, 6, 4], [7, 0, 5]], Solution).
