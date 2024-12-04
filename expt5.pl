% Define the edges of the graph with their costs
edge(a, b, 1).
edge(a, c, 4).
edge(b, d, 2).
edge(b, e, 5).
edge(c, f, 3).
edge(d, g, 2).
edge(e, g, 1).
edge(f, g, 6).

% Define the heuristic (estimated cost to the goal)
heuristic(a, 7).
heuristic(b, 6).
heuristic(c, 5).
heuristic(d, 4).
heuristic(e, 2).
heuristic(f, 3).
heuristic(g, 0).  % Goal node has heuristic 0

% Best First Search main predicate
best_first_search(Start, Goal, Path) :-
    best_first_search_helper([[Start]], Goal, Path).

% Helper predicate to perform BFS
best_first_search_helper([[Goal|Rest]|_], Goal, Path) :-
    reverse([Goal|Rest], Path). % Goal reached, return the path

best_first_search_helper([CurrentPath|OtherPaths], Goal, Path) :-
    CurrentPath = [CurrentNode|_],
    findall([NextNode|CurrentPath],
            (edge(CurrentNode, NextNode, _), \+ member(NextNode, CurrentPath)),
            NewPaths),
    add_heuristic(NewPaths, Goal, ScoredPaths),
    append(OtherPaths, ScoredPaths, AllPaths),
    sort(1, @=<, AllPaths, SortedPaths),
    best_first_search_helper(SortedPaths, Goal, Path).

% Add heuristic score to paths
add_heuristic([], _, []).
add_heuristic([[Node|Rest]|Paths], Goal, [[Score, [Node|Rest]]|ScoredPaths]) :-
    heuristic(Node, Score),
    add_heuristic(Paths, Goal, ScoredPaths).

% Query example:
% ?- best_first_search(a, g, Path).


