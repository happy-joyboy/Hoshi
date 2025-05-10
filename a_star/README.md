# 🌟 MIPS A* Pathfinding Algorithm Implementation
<div align="center">
  <img src="https://img.shields.io/badge/Language-MIPS%20Assembly-blue" alt="Language">
  <img src="https://img.shields.io/badge/Algorithm-A*%20Pathfinding-green" alt="Algorithm">
  <img src="https://img.shields.io/badge/Visualization-Bitmap%20Display-orange" alt="Visualization">
</div>
📝 Overview
This project is a comprehensive implementation of the A* pathfinding algorithm in MIPS assembly language. A* is one of the most efficient pathfinding algorithms that finds the shortest path between two points while avoiding obstacles. This implementation includes a visual representation using the MIPS bitmap display, showing the algorithm's step-by-step progress and the final path.

A* (pronounced "A-star") is a popular pathfinding algorithm used in computer science and artificial intelligence. It combines the advantages of Dijkstra's algorithm (which guarantees the shortest path) and greedy best-first search (which uses heuristics to improve performance). A* is widely used in applications such as video games, robotics, and navigation systems.

## Data Structures

### Movement Directions

The program defines two sets of movement directions:
```assembly
# Movement directions (4-way: up, right, down, left)
d4x:                .word       0, 1, 0, -1
d4y:                .word       -1, 0, 1, 0

# Or 8-way movement (includes diagonals)
d8x:                .word       0, 1, 1, 1, 0, -1, -1, -1
d8y:                .word       -1, -1, 0, 1, 1, 1, 0, -1
```

- `d4x` and `d4y`: Define 4-way movement (cardinal directions)
- `d8x` and `d8y`: Define 8-way movement (including diagonals)

The program primarily uses 4-way movement for its pathfinding, though 8-way movement is defined and could be used with minor modifications.

### Node Structure

Each node in the grid is represented by a data structure with the following attributes:

```assembly
.eqv        x, 0          # x-coordinate (offset 0)
.eqv        y, 4          # y-coordinate (offset 4)
.eqv        wall, 8       # wall status (offset 8)
.eqv        gScore, 12    # cost from start (offset 12)
.eqv        hScore, 16    # heuristic cost to goal (offset 16)
.eqv        fScore, 20    # total cost (g + h) (offset 20)
.eqv        parent_x, 24  # parent node x-coordinate (offset 24)
.eqv        parent_y, 28  # parent node y-coordinate (offset 28)
```

This structure enables tracking of all necessary information for the A* algorithm, including:
- Position in the grid
- Whether the position is a wall/obstacle
- Path costs (g, h, and f scores)
- Parent node for path reconstruction

## Main Components

### Main Function

The `main` function initializes the program by:
1. Setting up the stack pointer
2. Clearing the screen
3. Drawing the grid
4. Highlighting the start and goal positions
5. Adding a brief delay
6. Calling the A* algorithm implementation

### A* Algorithm Implementation

The A* algorithm is implemented in the `a_star` function, which follows these steps:

1. **Initialization**:
   - Calls `initialize_nodes` to set up the node data structures
   - Adds the starting node to the open set with a g-score of 0
   - Calculates the h-score (Manhattan distance to the goal)
   - Calculates the f-score (g-score + h-score)
   - Pushes the start node to the open set (priority queue)

2. **Main Loop**:
   - Continues until the open set is empty or the goal is found
   - Pops the node with the lowest f-score from the open set
   - Checks if the popped node is the goal
   - If not, adds the node to the closed set and processes its neighbors

3. **Neighbor Processing**:
   - For each neighbor in the 4 cardinal directions:
     - Calculates its coordinates
     - Checks if it's a valid position (within bounds and not an obstacle)
     - Checks if it's already in the closed set
     - Calculates a tentative g-score
     - Updates the g-score if the tentative score is better
     - Calculates the h-score and f-score
     - Stores the node's parent for path reconstruction
     - Pushes the neighbor to the open set

4. **Path Reconstruction**:
   - If a path is found, it traces back from the goal to the start using parent pointers
   - Visualizes the final path on the grid

## Helper Functions
Function Documentation
Core A* Functions

   **a_star**:

      - The main A* algorithm implementation. Initializes structures, runs the search loop, and handles path reconstruction.

   **is_valid_position**

      - Parameters: a0 = x, a1 = y
      - Returns: v0 = 1 if valid, 0 if invalid
      - Description: Checks if a position is within map boundaries and not an obstacle.

   **is_in_closed_set**

      - Parameters: a0 = x, a1 = y
      - Returns: v0 = 1 if in closed set, 0 otherwise
      - Description: Determines if a node has already been fully evaluated.

   **add_to_closed_set**

      - Parameters: a0 = x, a1 = y
      - Description: Marks a node as fully evaluated.

   **chebyshevDistance**

      - Parameters: a0 = x1, a1 = y1, a2 = x2, a3 = y2
      - Returns: Chebyshev distance between two points
      - Description: Heuristic function for the A* algorithm.

   ### Priority Queue Functions
   
   **push**

      - Parameters: a0 = x, a1 = y, a2 = parent, a3 = f-score
      - Description: Adds a node to the priority queue.

   **pop**

      - Description: Extracts the node with the lowest f-score.
      - Side Effect: Places the extracted node in the extracted_node structure.

   ### Node Management Functions
   
   **initialize_nodes**

      - Description: Sets up initial node values for all grid positions.

   **set_g_score, get_g_score, set_f_score, get_f_score**

      - Description: Accessor/mutator functions for node scores.

   **drawGridNode**

      - Parameters: a0 = x, a1 = y, a2 = status
      - Description: Updates the visual representation of nodes during algorithm execution.

   **printSolution**

      - Description: Reconstructs and displays the final path.


## Performance Considerations

- The use of a priority queue ensures optimal performance for node selection
- Closed set implementation prevents redundant node evaluation
- Visualization features may slow execution but enhance understanding

## Visualization Color Scheme

The code uses a consistent color scheme for visualization:
- Start position: Color code 8
- Goal position: Color code 2 (green)
- Current node being explored: Color code 5 (yellow)
- Nodes in the open set: Color code 9 (gray)
- Final path: Color code 3 (green)

## Included Files

The implementation references several included files:
- **Priority Queue** (`pq.asm`): Implementation of a min-heap for the open set
- **Node Management** (`node_list.asm`): Functions for manipulating node data structures
- **Heuristic Functions** (`h_calc.asm`): Distance calculation functions
- **Support Functions** (`new.asm`): Additional helper functions


## Conclusion

This MIPS assembly implementation of the A* pathfinding algorithm demonstrates both the algorithm's functionality and its visualization. The real-time visualization helps in understanding how A* efficiently finds the shortest path by combining the best of Dijkstra's algorithm and greedy best-first search.

The implementation is well-structured, with clear separation between the core algorithm, data structures, and visualization components. It could be extended to support 8-way movement, different heuristics, or more complex grid environments.