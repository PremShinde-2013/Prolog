% Define the edges of the graph
edge(a, b).
edge(a, c).
edge(b, d).
edge(b, e).
edge(c, f).
edge(e, g).
edge(f, g).

% Main predicate to find a path using DFS
dfs(Start, Goal, Path) :-
    dfs_helper(Start, Goal, [Start], Path).

% Helper predicate to perform DFS
dfs_helper(Goal, Goal, Visited, Path) :-
    reverse(Visited, Path).   % If the current node is the goal, return the path.

dfs_helper(Current, Goal, Visited, Path) :-
    edge(Current, Next),      % Find an adjacent node.
    \+ member(Next, Visited), % Ensure the node has not been visited.
    dfs_helper(Next, Goal, [Next|Visited], Path). % Recur to continue the search.

% Query example:
% ?- dfs(a, g, Path).
