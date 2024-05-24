# minimal-surface-area
A course project to write a program to minimize surface area using CVX in Matlab

Visualizations:

<img src="surfaceArea1.png" alt="screenshot" width=25% height=25%> <img src="surfaceArea2.png" alt="screenshot" width=25% height=25%> 
<img src="surfaceArea3.png" alt="screenshot" width=25% height=25%> <img src="surfaceArea4.png" alt="screenshot" width=25% height=25%> 
<img src="surfaceArea5.png" alt="screenshot" width=25% height=25%> <img src="surfaceArea6.png" alt="screenshot" width=25% height=25%>

To accomplish this approximation of a minimal surface, I first created a 2D triangulation and fixed the boundary points of the shape I wanted to minimize. For example, in the bendy pringle example, each point on the outside of that circle was fixed at the right 3D coordinate. Then, using CVX in MatLab, I minimized the sum of the areas of all of the triangulations under the condition that the boundary points were fixed. This produced a pretty good approximation of a minimal surface that became more accurate as the triangulation was refined. 

While this isn't necessarily the most efficient way to complete this task, it was good practice working with CVX in MatLab and turning theoretical math into a cool, working algorithm with visualizations.
