% Step 1: Define the main predicate to solve the problem
solve_queens(Solution) :-
    length(Solution, 8),        % Ensure the solution is a list of 8 elements (one for each queen)
    place_queens(Solution),     % Generate a possible arrangement of queens
    safe(Solution).             % Check if the arrangement is safe (no queens attack each other)

% Step 2: Place queens on the board
place_queens([]).               % Base case: No queens left to place
place_queens([Q|Others]) :-
    place_queens(Others),       % Place the other queens first
    member(Q, [1,2,3,4,5,6,7,8]), % Place this queen in a valid row
    \+ member(Q, Others).       % Ensure no two queens are in the same row

% Step 3: Check if the arrangement is safe
safe([]).                       % Base case: No queens left to check
safe([Q|Others]) :-
    safe(Others),               % Ensure the rest of the queens are safe
    no_attack(Q, Others, 1).    % Ensure this queen does not attack the others

% Step 4: Ensure no attacks
no_attack(_, [], _).            % Base case: No queens left to check for attack
no_attack(Q, [Q1|Others], Dist) :-
    Q =\= Q1,                   % Queens are not in the same row
    abs(Q1 - Q) =\= Dist,       % Queens are not on the same diagonal
    D1 is Dist + 1,             % Increment the distance for the next queen
    no_attack(Q, Others, D1).   % Check the rest of the queens

% Query to find a solution:
% ?- solve_queens(Solution).
