% Define the graph as edges with weights
edge(a, b, 10).
edge(a, c, 15).
edge(a, d, 20).
edge(b, c, 35).
edge(b, d, 25).
edge(c, d, 30).

% Make edges bidirectional
cost(X, Y, C) :- edge(X, Y, C).
cost(X, Y, C) :- edge(Y, X, C).

% Solve the TSP
solve_tsp(Start, Path, Cost) :-
    findall(City, connected(Start, City), Cities),
    permute(Cities, Perm),
    find_cost([Start | Perm], Cost),
    Path = [Start | Perm].

% Check if two cities are connected
connected(X, Y) :- cost(X, Y, _).

% Calculate the cost of a path
find_cost([_], 0).
find_cost([City1, City2 | Rest], Cost) :-
    cost(City1, City2, C),
    find_cost([City2 | Rest], RestCost),
    Cost is C + RestCost.

% Generate permutations of a list
permute([], []).
permute(List, [H|Perm]) :-
    select(H, List, Rest),
    permute(Rest, Perm).

% Select an element from a list
select(X, [X|T], T).
select(X, [H|T], [H|R]) :-
    select(X, T, R).



command

solve_tsp(a, Path, Cost).