% Define the edges of the graph with costs
edge(a, b, 1).
edge(a, c, 4).
edge(b, d, 2).
edge(b, e, 5).
edge(c, f, 3).
edge(d, g, 2).
edge(e, g, 1).
edge(f, g, 6).

% Define heuristic values
heuristic(a, 7).
heuristic(b, 6).
heuristic(c, 5).
heuristic(d, 4).
heuristic(e, 2).
heuristic(f, 3).
heuristic(g, 0). % Goal node has a heuristic value of 0

% Main predicate to find a path using Best First Search
best_first_search(Start, Goal, Path) :-
    bfs([[Start]], Goal, Path).

% Helper predicate: BFS core
bfs([[Goal|Rest]|_], Goal, Path) :-
    reverse([Goal|Rest], Path). % Found the goal, return the path.

bfs([CurrentPath|OtherPaths], Goal, Path) :-
    CurrentPath = [CurrentNode|_],   % Get the current node from the path.
    findall([NextNode|CurrentPath],
            (edge(CurrentNode, NextNode, _), \+ member(NextNode, CurrentPath)),
            NewPaths),               % Explore adjacent nodes that are not yet visited.
    add_with_heuristic(NewPaths, Goal, OtherPaths, UpdatedPaths),
    bfs(UpdatedPaths, Goal, Path).   % Recursively continue BFS.

% Helper predicate: Add paths with heuristics
add_with_heuristic([], _, Paths, Paths).
add_with_heuristic([NewPath|NewPaths], Goal, CurrentPaths, UpdatedPaths) :-
    NewPath = [Node|_],
    heuristic(Node, Heuristic),
    insert_by_heuristic([Heuristic, NewPath], CurrentPaths, TempPaths),
    add_with_heuristic(NewPaths, Goal, TempPaths, UpdatedPaths).

% Helper predicate: Insert paths based on heuristic values
insert_by_heuristic(NewPath, [], [NewPath]).
insert_by_heuristic(NewPath, [Path|Paths], [NewPath, Path|Paths]) :-
    NewPath = [H1, _],
    Path = [H2, _],
    H1 =< H2, !. % Insert NewPath before Path if its heuristic is smaller.
insert_by_heuristic(NewPath, [Path|Paths], [Path|UpdatedPaths]) :-
    insert_by_heuristic(NewPath, Paths, UpdatedPaths).

% Query example:
% ?- best_first_search(a, g, Path).
