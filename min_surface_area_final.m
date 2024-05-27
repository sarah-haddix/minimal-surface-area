%% Flat Plane %%
% nxn grid of numbers
n = 10;

% use meshgrid to generate grid of unit square
[x, y] = meshgrid(linspace(0, 1, n), linspace(0, 1, n));

% matrices -> vectors
xy = [x(:) y(:)];

% triangulation, boundary
triangulation = delaunayTriangulation(xy);
boundary = triangulation.freeBoundary();

% plot triangulation
figure;
triplot(triangulation);
title('Triangulation of Unit Square');
xlabel('X');
ylabel('Y');

%%%%%%%%%%%% Optimization %%%%%%%%%%%%%
% # of points
p = n*n;
% get connectivity list
C = triangulation.ConnectivityList;

% get matrix I need
resultMatrix = createCustomMatrix(C, p);


%%% CVX %%%
cvx_begin
    % create z-variable
    variable z(p)
    
    % objective
    minimize( norm(resultMatrix*z, 2) )


    
    % constraints
    subject to
        %% Boundary conditions %%
        % Iterate over all elements in indexMatrix
        for i = 1:numel(boundary)
            % Get the index from the matrix
            idx = boundary(i);
    
            % Check if idx is within the bounds of z
            if idx <= p
                % Set the corresponding entry in z to 0
                z(idx) == 0;
            end
        end

        
cvx_end


%% 3d Plot of Flat Plane%%
% Extract connectivity list and point coordinates
tri = triangulation.ConnectivityList;
x = triangulation.Points(:, 1);
y = triangulation.Points(:, 2);

% Create a 3D plot using trisurf
figure;
trisurf(tri, x, y, z);
axis vis3d 
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Minimal Surface Area of Flat Plane');
colorbar;
daspect([1 1 1]);








%% Bendy Rectangle %%
% We use a few more points to create a meshgrid that spans [-1, 1]
% nxn grid of numbers
n = 100;

% use meshgrid to generate grid of square
[x, y] = meshgrid(linspace(-1, 1, n), linspace(-1, 1, n));

% matrices -> vectors
xy = [x(:) y(:)];

% triangulation, boundary
triangulation = delaunayTriangulation(xy);
boundary = triangulation.freeBoundary();


%%%%%%%%%%%% Optimization %%%%%%%%%%%%%
% # of points
p = n*n;
% get connectivity list
C = triangulation.ConnectivityList;

% get matrix I need
resultMatrix = createCustomMatrix(C, p);


%%% CVX %%%
cvx_begin
% create z-variable
variable z(p)

% objective
minimize( norm(resultMatrix*z, 2) )


% We then update our constraints to “lift” up the edges of the square to height 10
% constraints
subject to
%% Boundary conditions %%
% Iterate over all elements in indexMatrix
for i = 1:numel(boundary)
    % Get the index from the matrix
    idx = boundary(i);

    % Check if idx is within the bounds of z
    if idx <= p
        % Set the corresponding entry in z to 0
        z(idx) == x(idx).^2 * 10;
    end
end


cvx_end



%% 3D Plot of Bendy Rectangle %%
% We adjust our visualization slightly to account for the new aspect ratio.
% Extract connectivity list and point coordinates
tri = triangulation.ConnectivityList;
x = triangulation.Points(:, 1);
y = triangulation.Points(:, 2);

% Create a 3D plot using trisurf
figure;
trisurf(tri, x, y, z, 'EdgeColor', 'none');
axis vis3d
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Minimal Surface Area of Bendy Rectangle');
colorbar;
daspect([1 1 10]);








%% Pringle Thing %%
% Here, the square grid is traded for a circular one.
% nxn grid of numbers
n = 50;

%%% Create a meshgrid of the unit circle%%%
% Create a linearly spaced vector from -1 to 1 with n points
xTEMP = linspace(-1, 1, n);
yTEMP = linspace(-1, 1, n);

% Create a meshgrid from these vectors
[X, Y] = meshgrid(xTEMP, yTEMP);

% Compute the radius for each point on the grid
R = sqrt(X.^2 + Y.^2);

% Use only the points where the radius is less than or equal to 1 (inside the unit circle)
x = X(R <= 1);
y = Y(R <= 1);

% matrices -> vectors
xy = [x(:) y(:)];

% triangulation, boundary
triangulation = delaunayTriangulation(xy);
boundary = triangulation.freeBoundary();


%%%%%%%%%%%% Optimization %%%%%%%%%%%%%
% # of points
p = length(x);
% get connectivity list
C = triangulation.ConnectivityList;

% get matrix I need
resultMatrix = createCustomMatrix(C, p);


%%% CVX %%%
cvx_begin
% create z-variable
variable z(p)

% objective
minimize( norm(resultMatrix*z, 2) )


% We update our constraints in the same way as before to “lift” two ends up the pringle up by 10
% constraints
subject to
%% Boundary conditions %%
% Iterate over all elements in indexMatrix
for i = 1:numel(boundary)
    % Get the index from the matrix
    idx = boundary(i);

    % Check if idx is within the bounds of z
    if idx <= p
        % Set the corresponding entry in z to 0
        z(idx) == x(idx).^2 * 10;
    end
end



cvx_end



%% 3D Plot of Pringle Thing %%
% We adjust our visualization slightly to account for the new aspect ratio.
% Extract connectivity list and point coordinates
tri = triangulation.ConnectivityList;
x = triangulation.Points(:, 1);
y = triangulation.Points(:, 2);

% Create a 3D plot using trisurf
figure;
trisurf(tri, x, y, z, 'EdgeColor', 'none');
axis vis3d
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Minimal Surface Area of Pringle Thing');
colorbar;
daspect([1 1 10]);







%%% Function to create the matrix I need %%%
%{
    This function creates a matrix using the connectivity list of the
    triangulation C and the number of points p. The new matrix has 2 rows
    for every 1 row in C and p columns. Each of these two rows created for
    each one row in C has a -1 in the column number specified by the first
    number of the row. The first row has a 1 in the column number specified
    by the second number in the row and the second row as a 1 in the column
    number specified by the third number in the row. There are 0s in every
    other position. 

    This matrix is multiplied with the vector z of height values in order
    to create the vectors that form the sides of each triangle. Minimizing
    the norm of these vectors is equivalent to minimizing the sum of the
    areas of each triangle, as discussed in class. Minimizing the sum of the areas of                                                                                            each triangle amounts to minimizing the surface, thus generate the minimal surface visualization.
%}

function resultMatrix = createCustomMatrix(C, p)
    % Extract the number of rows in C
    s = size(C, 1);

    % Initialize the result matrix of size 2s x p with all zeros
    resultMatrix = zeros(2 * s, p);

    % Loop through each row of C to set the appropriate elements
    for i = 1:s
        % First row modifications (2i-1)
        % -1 at the position specified by the first element in the row of C
        resultMatrix(2 * i - 1, C(i, 1)) = -1;
        % 1 at the position specified by the second element in the row of C
        resultMatrix(2 * i - 1, C(i, 2)) = 1;

        % Second row modifications (2i)
        % -1 at the position specified by the first element in the row of C
        resultMatrix(2 * i, C(i, 1)) = -1;
        % 1 at the position specified by the third element in the row of C
        resultMatrix(2 * i, C(i, 3)) = 1;
    end
end
