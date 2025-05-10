# 🌟 Hoshi: A* Pathfinding Algorithm in MIPS Assembly

## 📝 Overview

**Hoshi** (星, Japanese for "star") is a complete implementation of the A* pathfinding algorithm in MIPS assembly language. This project demonstrates low-level programming concepts by implementing a complex algorithmic solution in assembly language, offering valuable insights into computer architecture and optimization techniques.

## 🚀 Features of our Project

- **✅ Complete A* algorithm implementation** in pure MIPS assembly
- **✅ Priority Queue** with efficient insertion and extraction operations
- **✅ Manhattan Distance Heuristic** for optimal path calculation
- **✅ Visual Representation** through bitmap display for step-by-step algorithm progression
- **✅ Obstacle Detection** with robust path planning around barriers
- **✅ Path Reconstruction** with visual highlighting of the optimal route

## 🔍 What is A*?

A* (pronounced "A-star") is an informed search algorithm widely used in pathfinding and graph traversal. It efficiently plots a traversable path between multiple nodes by maintaining a priority queue of paths and choosing the lowest-cost path to expand.


🔁 How Algorithm work

    🔹 Initialize:

        openList: contains nodes yet to be evaluated (starts with start node).

        closedList: stores nodes already evaluated (starts empty).

        Set start.g = 0: cost from start to start.

        Set start.h = heuristic(start, goal): estimated cost from start to goal.

        Compute start.f = start.g + start.h.

        Set start.parent = null: no parent yet.

    🔹 Main loop: While openList is not empty:

        Select current as the node in openList with the lowest f value (best candidate).

        Goal check:

            If current == goal, return the reconstructed path using reconstruct_path(current).

        Move current node:

            Remove current from openList.

            Add current to closedList.

        Process neighbors:

            For each neighbor of current:

                Skip if the neighbor is already in closedList.

                Compute tentative_g = current.g + distance(current, neighbor).

                If neighbor is not in openList:

                    Add it to openList.

                Else if a better path isn't found:

                    If tentative_g >= neighbor.g, skip (existing path is better).

                Otherwise (this path is better):

                    Update neighbor.parent = current to trace the path later.

                    Update neighbor.g = tentative_g.

                    Update neighbor.h = heuristic(neighbor, goal).

                    Recompute neighbor.f = neighbor.g + neighbor.h.

    ❌ If loop ends with no path found:

        Return failure: no path exists between start and goal.

🔄 Path Reconstruction Function: reconstruct_path(current)

    Start from current (which is the goal node).

    Trace back using parent links, adding each node to a list.

    Stop when current is null (reached the start).

    Return the path in reverse (from start to goal).

# Modules

## 1- Priority queue

## 🔍 Overview

This repository provides a complete **min-priority queue** implementation in MIPS assembly language, based on a binary heap data structure. It is designed to be used in algorithmic problems like A\* search and Dijkstra's algorithm, where fast retrieval and insertion based on priority are crucial.

## ✨ Features

* ⚡ **Efficient Runtime**: `O(log n)` complexity for `push` and `pop` operations
* 🔄 **Heap-Based Min-Priority Queue**: Ensures minimal `fScore` node stays at root
* 🧠 **Each Node Contains**:

  * `(x, y)` coordinates
  * `parent` node reference
  * `fScore` (priority metric)
* 🖥️ **Debugging Utilities**: `print_heap` and `print_EX_node` functions
* 🔍 **Node Lookup**: `find_node` enables searching nodes by coordinates

## 🔧 Implementation Details

### Heap Structure

Nodes are arranged in a binary heap using a linear array. Each node occupies **16 bytes**:

```
Offset  Field     Size (bytes)
0       x         4
4       y         4
8       parent    4
12      fScore    4
```

This structure ensures the smallest `fScore` node is always at index `0`, with child nodes following the binary heap rule.

### Binary Heap Properties

* Left child index: `2*i + 1`
* Right child index: `2*i + 2`
* Parent index: `(i - 1) / 2`

Heap operations like bubbling up/down are implemented to maintain this structure.

## 🚀 Usage

1. Include required assembly files:

```assembly
.include "data_pq.asm"
.include "pq_functions.asm"
```

2. Use the API:

```assembly
# Push a node into the priority queue
li $a0, 5          # x
li $a1, 10         # y
li $a2, 0          # parent
li $a3, 15         # fScore
jal push

# Pop the node with the lowest fScore
jal pop
jal print_EX_node  # Display the extracted node
```

## 📚 Functions Explained

### `push`

Inserts a node into the priority queue.

#### Inputs:

* `$a0` = x coordinate
* `$a1` = y coordinate
* `$a2` = parent reference
* `$a3` = fScore

#### Steps:

1. Check if the heap is full.
2. Store the new node at the end of the heap.
3. Increment `heapSize`.
4. Perform **bubble-up** to restore min-heap property:

   * Swap with parent until the `fScore` is greater than or equal to the parent's.

### `pop`

Removes and returns the node with the lowest `fScore`.

#### Returns:

* Stores the extracted node in the `extracted_node` memory location.

#### Steps:

1. If the heap is empty, print a message and exit.
2. Copy the root node to `extracted_node`.
3. Move the last element to root.
4. Decrement `heapSize`.
5. Perform **bubble-down**:

   * Compare the current node with its children.
   * Swap with the smaller child until heap property is restored.

### `print_heap`

Prints all nodes in the heap for visualization and debugging.

### `print_EX_node`

Displays the last extracted node after a `pop` operation.

### `find_node`

Finds a node in the heap by coordinates.

#### Inputs:

* `$a0` = x coordinate
* `$a1` = y coordinate

#### Output:

* `$v0` = address of node if found; 0 if not found

#### Process:

* Iterates through the heap and compares stored x and y values with input.

## 📊 Performance

| Operation | Time Complexity |
| --------- | --------------- |
| `push`    | O(log n)        |
| `pop`     | O(log n)        |
| `peek`    | O(1)            |

## 2- Node list

### Node Structure
Each node in the grid has the following properties stored in memory:
```
Node {
    int x;           // X coordinate in grid
    int y;           // Y coordinate in grid
    int wall;        // 1 if wall/obstacle, 0 if traversable
    int gScore;      // Cost from start to this node
    int hScore;      // Heuristic estimate from this node to goal
    int fScore;      // gScore + hScore (total estimated cost)
    int parent_x;    // X coordinate of parent node in path
    int parent_y;    // Y coordinate of parent node in path
}
```

The implementation uses a fixed-size array `nodes` to store all nodes in the grid. The node's position in memory is calculated based on its coordinates.

## 🧠 Core Methods Analysis

### `initialize_nodes`
```assembly
initialize_nodes:
    # Function setup and register saving
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)
    
    # Initialize variables and pointers
    jal     clearScreen
    la      $s0, nodes                # Base node address
    la      $s1, map_data             # Map data pointer
    lw      $s2, map_width            # Grid dimensions
    lw      $s3, map_height
    
    # Main nested loops to process each cell
    li      $s4, 0                    # Row counter (y)
row_loop:
    beq     $s4, $s3, _done           # If row counter equals row count, exit loop
    li      $s5, 0                    # Column counter (x)

col_loop:
    beq     $s5, $s2, next_row        # If column counter equals column count, go to next row

    # Calculate memory addresses
    # ...address calculations...
    
    # Initialize node properties
    sw      $s5, x($t2)               # Store Column index in node
    sw      $s4, y($t2)               # Store row index in node
    lw      $t5, 0($t1)               # Get map value
    sw      $t5, wall($t2)            # Store wall status in node
    
    # A* specific initializations
    li      $t6, 999
    sw      $t6, gScore($t2)          # Initialize gScore to 999 (infinity)
    li      $t6, 0
    sw      $t6, hScore($t2)          # Initialize hScore
    add     $t6, $t6, $t6
    sw      $t6, fScore($t2)          # Initialize fScore
    li      $t6, 0
    sw      $t6, parent_x($t2)        # Initialize parent coordinates
    sw      $t6, parent_y($t2)
    
    # Visualization
    move    $a0, $s5                  # x coordinate
    move    $a1, $s4                  # y coordinate
    move    $a2, $t5                  # node type (wall or not)
    jal     drawGridNode              # Draw node on screen
    
    # Continue loop
    addi    $s5, $s5, 1               # Next column
    lw      $t7, nodes_count
    addi    $t7, $t7, 1
    sw      $t7, nodes_count
    j       col_loop

next_row:
    addi    $s4, $s4, 1               # Increment row counter
    j       row_loop

_done:
    lw      $ra, 0($sp)               # Restore return address
    addi    $sp, $sp, 4               # Restore stack pointer
    jr      $ra
```

This procedure:
1. Sets up a 2D grid representation based on map data
2. Initializes each node with default A* algorithm values
3. Renders the initial grid state visually
4. Uses nested loops for efficient grid traversal

### Score Management Functions

#### `set_g_score` and `get_g_score`
```assembly
# Sets the g-score (cost from start) for a node at (x,y)
set_g_score:
    # Calculate node address from x,y coordinates
    lw      $t0, map_width
    mul     $t1, $a1, $t0             # t1 = y * width
    add     $t1, $t1, $a0             # t1 = y * width + x
    lw      $t2, node_size
    mul     $t3, $t1, $t2             # t3 = index * node_size
    la      $t4, nodes
    add     $t4, $t4, $t3             # t4 = &nodes[index]
    
    # Update the gScore field
    sw      $a2, gScore($t4)          # Store the new gScore value
    jr      $ra

# Gets the g-score for a node at (x,y)
get_g_score:
    # Similar address calculation as set_g_score
    # ...address calculations...
    
    # Retrieve the gScore
    lw      $v0, gScore($t4)          # Load the gScore value
    jr      $ra
```

These functions handle the critical g-score component of A*, representing the actual cost from the start node. Similar patterns are implemented for f-score.

### Path Construction

```assembly
constructPathProcedure:
    # Function setup
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)
    
    # Check if we've reached the start node (base case)
    lw      $s0, start_x
    lw      $s1, start_y
    bne     $a0, $s0, constructPath_next_parent
    bne     $a1, $s1, constructPath_next_parent
    
    # If at start node, return
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra
    
constructPath_next_parent:
    # Save current coordinates
    move    $s6, $a0
    move    $s7, $a1
    
    # Find parent node
    # ...address calculations...
    lw      $t3, parent_x($t0)        # Load parent coordinates
    lw      $t4, parent_y($t0)
    
    # Recursive call to process parent node first
    move    $a0, $t3                  # Set parent coordinates as arguments
    move    $a1, $t4
    
    # Save current node coordinates on stack
    addi    $sp, $sp, -8
    sw      $s6, 0($sp)
    sw      $s7, 4($sp)
    
    # Recursive call
    jal     constructPathProcedure
    
    # Restore coordinates
    lw      $s6, 0($sp)
    lw      $s7, 4($sp)
    addi    $sp, $sp, 8
    
    # Visualize this node as part of the path
    move    $a0, $s6
    move    $a1, $s7
    li      $a2, 5                    # Path visualization color/type
    jal     drawGridNode
    
    # Delay for visualization
    li      $v0, 32
    li      $a0, 100
    syscall
    
    # Return
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra
```

This procedure recursively constructs and visualizes the path from goal to start by:
1. Checking if we've reached the start node (base case)
2. If not, recursively processing the parent node first (ensuring start-to-goal order)
3. Drawing the node as part of the path after the recursive call returns
4. Using stack to manage recursive calls and preserve registers

## 🔍 Technical Implementation Details

### Memory Address Calculation Pattern

The code follows a consistent pattern to locate a node in memory:
```assembly
# Calculate node address from coordinates (x,y)
lw      $t0, map_width
mul     $t1, $a1, $t0             # row * width
add     $t1, $t1, $a0             # row * width + column = linear index
lw      $t2, node_size            
mul     $t3, $t1, $t2             # index * node_size = byte offset
la      $t4, nodes                # base address
add     $t4, $t4, $t3             # base + offset = node address
```

This pattern effectively implements the formula: `&nodes[y * width + x]` to convert 2D coordinates to memory addresses.

### Register Usage Strategy

The implementation uses registers strategically:
- `$s0-$s7`: Preserved across function calls, used for important loop variables
- `$t0-$t7`: Temporary values, not preserved across calls
- `$a0-$a3`: Function arguments
- `$v0-$v1`: Function return values
- `$ra`: Return address register, carefully preserved on stack

### Stack Management

The code handles the stack properly for function calls:
```assembly
# Function prologue
addi    $sp, $sp, -4      # Allocate stack space
sw      $ra, 0($sp)       # Save return address

# Function body
# ...

# Function epilogue
lw      $ra, 0($sp)       # Restore return address
addi    $sp, $sp, 4       # Deallocate stack space
jr      $ra               # Return
```

For recursive calls, additional registers are saved:
```assembly
addi    $sp, $sp, -8      # Allocate more space
sw      $s6, 0($sp)       # Save registers
sw      $s7, 4($sp)
```

## 🔧 Optimization Techniques

1. **Register Usage**: Uses saved registers (`$s0-$s7`) for values needed across function calls
2. **Memory Access**: Calculates addresses efficiently to minimize memory accesses
3. **Code Structure**: Uses jump instructions to avoid redundant condition checks
4. **Data Organization**: Organizes node data for efficient access patterns

## 3- BitMap

## Overview
The module offers rendering functionality for the A* pathfinding visualization, providing essential graphics operations for displaying the grid, nodes, and algorithm progress.

## Data Segment
### Display and Grid Constants

```assembly
.eqv    displayWidth, 16       # Width of the display in units (512 / 32 = 16)
.eqv    displayHeight, 16      # Height of the display in units (512 / 32 = 16)
.eqv    gridCellWidth, 2       # Width of each grid cell in display units
.eqv    gridCellHeight, 2      # Height of each grid cell in display units
.eqv    gridWidth, 8           # Width of the grid in cells
.eqv    gridHeight, 8          # Height of the grid in cells
.eqv    bitmapBaseAddress, 0x10040000  # Memory address of the bitmap display
```

These constants define the dimensions and properties of both the display and the grid:
- `displayWidth` and `displayHeight`: Define the total dimensions of the bitmap display (16×16 units)
- `gridCellWidth` and `gridCellHeight`: Define the size of each grid cell (2×2 display units)
- `gridWidth` and `gridHeight`: Define the dimensions of the grid itself (8×8 cells)
- `bitmapBaseAddress`: The memory address where the bitmap display begins in MIPS memory

### Grid Data

This data structure represents the grid map where:
- `0`: Represents a free/passable cell
- `1`: Represents a wall/obstacle

The grid is an 8×8 matrix with strategic placement of obstacles to make the pathfinding problem meaningful.

### Color Table

The color table defines a palette of 13 colors (indexed 0-12) that can be used for rendering different elements of the grid. Each color is represented as a 24-bit RGB value.

## (Functions)

### clearScreen

```assembly
clearScreen:
    li      $t0,                bitmapBaseAddress
    li      $t1,                displayWidth
    mul     $t1,                $t1,                displayHeight
    sll     $t1,                $t1,                2
    add     $t1,                $t1,                bitmapBaseAddress
    li      $t2,                0x808080           # Gray color
clearLoop:
    sw      $t2,                0($t0)
    addi    $t0,                $t0,                4
    blt     $t0,                $t1,                clearLoop
    
    #delay
    li $a0, 20        # 20 milliseconds delay
    li $v0, 32        # syscall for sleep
    syscall

    jr      $ra
```

**Purpose:** Clears the entire bitmap display by filling it with a uniform gray color.

**Steps:**
1. Sets `$t0` to the base address of the bitmap
2. Calculates the total display size in bytes: width × height × 4 (each pixel is 4 bytes)
3. Sets `$t1` to point just beyond the last displayable pixel
4. Sets each pixel to the gray color (0x808080)
5. Adds a brief delay (20ms) for visual smoothness
6. Returns to the caller

### drawGrid

```assembly
# $a0 = base address, $a1 = free space color, $a2 = wall color
drawGrid:
    li      $s0,                0
    move    $s2,                $a0
outer_loop:
    bge     $s0,                gridHeight,         drawGridEnd
    li      $s1,                0
inner_loop:
    bge     $s1,                gridWidth,          outer_loop_next
    mul     $t0,                $s0,                gridWidth
    add     $t0,                $t0,                $s1
    sll     $t0,                $t0,                2
    add     $t0,                $t0,                $s2
    lw      $a2,                0($t0)
    move    $a0,                $s1
    move    $a1,                $s0
    addi    $sp,                $sp,                -4
    sw      $ra,                0($sp)
    jal     drawGridNode

    #delay
    li $a0, 10        # 10 milliseconds delay
    li $v0, 32        # syscall for sleep
    syscall

    addi    $s1,                $s1,                1
    j       inner_loop
outer_loop_next:
    addi    $s0,                $s0,                1
    j       outer_loop
drawGridEnd:
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4
    jr      $ra
```

**Purpose:** Renders the entire grid on the bitmap display, differentiating between passable cells and walls.

**Parameters:**
- `$a0`: Base address of the grid data
- `$a1`: Color index for free/passable cells
- `$a2`: Color index for wall/obstacle cells

**Steps:**
1. Uses nested loops to iterate through each cell in the grid (y in outer loop, x in inner loop)
2. Calculates the memory offset for the current grid cell
3. Loads the cell value (0 for free space, 1 for wall)
4. Uses this value as the color index for drawing the grid node
5. Adds a brief delay (10ms) between drawing each node for visual effect
6. Returns to caller after drawing the entire grid

### drawGridNode

```assembly
drawGridNode:
    # save return address
    addi    $sp,                $sp,                -4
    sw      $ra,                0($sp)

    # baseX = a0 * gridCellWidth
    li      $t5,                gridCellWidth
    mul     $t5,                $a0,                $t5
    move    $s7,                $t5

    # baseY = a1 * gridCellHeight
    li      $t6,                gridCellHeight
    mul     $t6,                $a1,                $t6

    addi    $t7,                $t5,                gridCellWidth
    addi    $t8,                $t6,                gridCellHeight

row_loop_bitmap:
    bge     $t6,                $t8,                finish
    move    $t5,                $s7
col_loop_bitmap:
    bge     $t5,                $t7,                next_row_bitmap
    move    $a0,                $t5
    move    $a1,                $t6
    jal     drawPixel
    addi    $t5,                $t5,                1
    j       col_loop_bitmap

next_row_bitmap:
    addi    $t6,                $t6,                1
    j       row_loop_bitmap

finish:
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4
    jr      $ra
```

**Purpose:** Draws a single grid node (cell) at the specified grid coordinates with the specified color.

**Parameters:**
- `$a0`: Grid x-coordinate
- `$a1`: Grid y-coordinate
- `$a2`: Color index for the node

**Steps:**
1. Converts grid coordinates to display coordinates by multiplying by cell dimensions
2. Calculates the boundaries of the cell in display coordinates
3. Uses nested loops to fill the entire cell area with pixels of the specified color
4. Returns to caller after the entire cell is drawn

### calculateAddress

```assembly
calculateAddress:
    li      $v0,                bitmapBaseAddress

    mul     $t0,                $a1,                displayWidth
    add     $t0,                $t0,                $a0
    sll     $t0,                $t0,                2
    add     $v0,                $v0,                $t0
    jr      $ra
```

**Purpose:** Calculates the memory address for a given display coordinate.

**Parameters:**
- `$a0`: Display x-coordinate
- `$a1`: Display y-coordinate

**Returns:**
- `$v0`: Memory address corresponding to the specified coordinates

**Steps:**
1. Starts with the base address of the bitmap display
2. Calculates the linear offset: (y * displayWidth + x) * 4 bytes per pixel
3. Adds this offset to the base address
4. Returns the resulting memory address

### getColor

```assembly
getColor:
    la      $t0,                colorTable
    sll     $t1,                $a2,                2
    add     $t0,                $t0,                $t1
    lw      $v1,                0($t0)
    jr      $ra
```

**Purpose:** Retrieves an RGB color value from the color table.

**Parameters:**
- `$a2`: Color index (0-12)

**Returns:**
- `$v1`: 24-bit RGB color value

**Steps:**
1. Loads the address of the color table
2. Multiplies the color index by 4 (since each color is 4 bytes)
3. Adds this offset to the color table address
4. Loads the RGB value from the calculated address
5. Returns this color value

### drawPixel

```assembly
drawPixel:
    bltz    $a0,                drawPixelexit
    bltz    $a1,                drawPixelexit
    bge     $a0,                displayWidth,       drawPixelexit
    bge     $a1,                displayHeight,      drawPixelexit
    addi    $sp,                $sp,                -4
    sw      $ra,                0($sp)
    jal     calculateAddress
    jal     getColor
    sw      $v1,                0($v0)
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4
    jr      $ra
drawPixelexit:
    jr      $ra
```

**Purpose:** Draws a single pixel at the specified display coordinates with the specified color.

**Parameters:**
- `$a0`: Display x-coordinate
- `$a1`: Display y-coordinate
- `$a2`: Color index

**Steps:**
1. Validates that the coordinates are within display bounds
2. Calculates the memory address for the pixel
3. Gets the RGB color value for the specified color index
4. Stores the color value at the calculated address
5. Returns to caller

## Integration with A* Algorithm

The bitmap helper module integrates with the A* pathfinding algorithm to visualize:

1. **The Grid**: Shows the layout of passable areas and obstacles
2. **Current Node**: Highlights the node currently being explored (typically in yellow)
3. **Open Set**: Shows nodes in the frontier (typically in gray)
4. **Closed Set**: Shows already explored nodes
5. **Final Path**: Once found, highlights the path from start to goal (typically in green)

The visualization is enhanced with strategic delays to make the algorithm's progress visible and comprehensible to human observers.

## Color Code Usage

The implementation uses various colors to represent different elements:
- **Color 0** (White): Background/free space
- **Color 1** (Black): Walls/obstacles
- **Color 2** (Green): Goal node and final path
- **Color 5** (Yellow): Current node being explored
- **Color 8** (Cyan): Start node
- **Color 9** (Gray): Nodes in the open set/frontier

This color coding makes it easy to distinguish between different elements of the visualization and understand the algorithm's progress.

## Performance Considerations

1. **Display Buffer**: Direct memory access to the bitmap display provides efficient rendering
2. **Strategic Delays**: Small delays are added to make the visualization comprehensible
3. **Pixel-perfect Rendering**: Each grid cell consists of multiple pixels for better visibility
4. **Boundary Checking**: The drawPixel function includes bounds checking to prevent memory access violations

## 🌟 Star file

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
