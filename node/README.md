# 🗺️ MIPS Node List Implementation - Detailed Analysis

## 🏗️ Data Structures

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

## 📊 Visualization Components

The code uses a helper function `drawGridNode` (imported from bitmap_helper.asm) to visualize:
- The initial grid with walls
- The search progress (nodes being evaluated)
- The final solution path

## 🧪 Debug Utilities

The `print_node_grid` function provides a textual representation of the grid for debugging:
```assembly
print_node_grid:
    # Nested loops for grid traversal
    # ...loops...
    
    # For each node, print its properties
    li      $v0, 4
    la      $a0, node_str
    syscall
    
    # Print x,y coordinates
    # ...
    
    # Print node properties (wall, gScore, hScore, etc.)
    # ...
    
    # Continue loop
    # ...
```

## 🔧 Optimization Techniques

1. **Register Usage**: Uses saved registers (`$s0-$s7`) for values needed across function calls
2. **Memory Access**: Calculates addresses efficiently to minimize memory accesses
3. **Code Structure**: Uses jump instructions to avoid redundant condition checks
4. **Data Organization**: Organizes node data for efficient access patterns
