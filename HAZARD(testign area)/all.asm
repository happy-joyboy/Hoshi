A* Pathfinding Algorithm in MIPS Assembly
Overview 🔍
This code implements the A* pathfinding algorithm in MIPS assembly language, with an integrated bitmap visualization. The program finds the shortest path between start and goal positions on a grid, avoiding obstacles.
Core Components 🧩
1. Data Structures

Priority Queue: Implemented as a min-heap with each node containing:

x, y coordinates
parent node reference
f-score (evaluation function)


Node Grid: Represents the search space where each node contains:

x, y coordinates
Wall status (obstacle or free)
g-score (cost from start)
h-score (heuristic estimate to goal)
f-score (g-score + h-score)
parent coordinates


Closed Set: Tracks visited nodes to avoid revisiting them

2. A* Algorithm Implementation
The main function a_star orchestrates the algorithm:
