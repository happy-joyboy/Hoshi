.data
str_space:      .asciiz " "
map_width:    .word 8
map_height:   .word 8

# Map data (0 = walkable, 1 = obstacle)
map_data:
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   0, 1, 0, 1, 0, 1, 0, 0                                      # Row 1
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   0, 0, 1, 0, 0, 1, 0, 1                                      # Row 4
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3
    # .word   0, 0, 1, 0, 0, 1, 0, 1                                      # Row 4

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 7
goal_y:       .word 7

nodes:          .word  0:576                                 # 64 nodes × 32 bytes
closed_set:     .word   0:64                                  # 1 node × 32 bytes
node_size:      .word   32                                  # Size of each node (32 bytes)
nodes_count:    .word   0                                   # Number of nodes created
    # Offsets for fields within the node structure
                .eqv    x, 0
                .eqv    y, 4
                .eqv    wall, 8                             # 4 bytes
                .eqv    gScore, 12
                .eqv    hScore, 16
                .eqv    fScore, 20
                .eqv    parent_x, 24
                .eqv    parent_y, 28


node_str:       .asciiz "Node ["
msg_coma:          .asciiz ","
wall_str:       .asciiz "] Wall: "
newline:        .asciiz "\n"

.text

nodeListMain:

    jal     initialize_nodes                                # Create node grid from map
    jal     print_node_grid     
    
                                # Verification print

    li      $v0,                10                          # Exit
    syscall

initialize_nodes:
    la      $s0,                nodes                       # Base node address
    la      $s1,                map_data                    # Map data pointer
    lw      $s2,                map_width                   # Grid dimensions
    lw      $s3,                map_height

    li      $s4,                0                           # Row counter (y)
row_loop:
    beq     $s4,                $s3,            _done       # If row counter equals row count, exit loop
    li      $s5,                0                           # Column counter (x)

col_loop:
    beq     $s5,                $s2,            next_row    # If column counter equals column count, go to next row

    # calc address of the node & map
    mul     $t0,                $s4,            $s2         # t0 = row * map_width
    add     $t0,                $t0,            $s5         # t0 = row * map_width + col
    sll     $t0,                $t0,            2           # t0 = (row * map_width + col) * 4
    add     $t1,                $s1,            $t0         # t1 = base + (row * map_width + col) * 4  -> map address

    mul     $t2,                $s4,            $s2
    add     $t2,                $t2,            $s5
    lw      $t3,                node_size
    mul     $t2,                $t2,            $t3         # × node_size
    add     $t2,                $s0,            $t2         # t3 = base + (row * map_width + col) * node_size -> node address

    # Store coordinates
    sw      $s5,                x($t2)                      # Store Column index in node
    sw      $s4,                y($t2)                      # Store row index in node

    # Store wall status
    lw      $t5,                0($t1)                      # Get map value
    sw      $t5,                wall($t2)                   # Store wall status in node

    # The star req
    li      $t6,                -1      
    sw      $t6,                gScore($t2)                 # Initialize gScore to -1 (unvisited) except start node:   (still will add it) 
    li      $t6,                0
    sw      $t6,                hScore($t2)                 # Initialize hScore to 0 (or any other value)
    add     $t6,                $t6,            $t6
    sw      $t6,                fScore($t2)                 # Initialize fScore to 2 (or any other value)
    li      $t6,                0
    sw      $t6,                parent_x($t2)               # Initialize parent_x to 0 (or any other value)
    li      $t6,                0
    sw      $t6,                parent_y($t2)               # Initialize parent_y to 0 (or any other value)



    # Increment counters
    addi    $s5,                $s5,            1           # Next column
    lw      $t7,                nodes_count
    addi    $t7,                $t7,            1
    sw      $t7,                nodes_count

    j       col_loop

next_row:
    addi    $s4,                $s4,            1           # Increment row counter
    j       row_loop

_done:
    jr      $ra

print_node_grid:
    la      $s0,                nodes           # Base node address
    lw      $s1,                map_width       # Grid width
    lw      $s2,                map_height      # Grid height
    
    li      $s3,                0               # Row counter (y)
print_row_loop:
    beq     $s3,                $s2,    print_end
    li      $s4,                0               # Column counter (x)

print_col_loop:
    beq     $s4,                $s1,    next_print_row

    # Calculate current node address
    mul     $t0,                $s3,    $s1    # row * width
    add     $t0,                $t0,    $s4    # + column
    lw      $t1,                node_size
    mul     $t0,                $t0,    $t1    # × node_size
    add     $t0,                $s0,    $t0    # base + offset

    # Print node details
    li      $v0,                4
    la      $a0,                node_str
    syscall

    li      $v0,                1
    lw      $a0,                x($t0)          # Print x (column index)
    syscall

    li      $v0,                4
    la      $a0,                msg_coma

    syscall

    li      $v0,                1
    lw      $a0,                y($t0)          # Print y (row index)
    syscall

    li      $v0,                4
    la      $a0,                wall_str
    syscall

    li      $v0,                1
    lw      $a0,                wall($t0)       # Print wall status
    syscall

    li      $v0,                4
    la      $a0,                msg_coma

    syscall

    li      $v0,                1
    lw      $a0,                gScore($t0)     # Print gScore
    syscall

    li      $v0,                4
    la      $a0,                msg_coma

    syscall

    li      $v0,                1
    lw      $a0,                hScore($t0)     # Print hScore
    syscall

    li      $v0,                4
    la      $a0,                msg_coma

    syscall

    li      $v0,                1
    lw      $a0,                fScore($t0)     # Print fScore
    syscall

    li      $v0,                4
    la      $a0,                msg_coma

    syscall

    li      $v0,                1
    lw      $a0,                parent_x($t0)   # Print parent_x
    syscall

    li      $v0,                4
    la      $a0,                msg_coma

    syscall

    li      $v0,                1
    lw      $a0,                parent_y($t0)   # Print parent_y
    syscall

    li      $v0,                4
    la      $a0,                newline
    syscall

    addi    $s4,                $s4,    1       # Next column
    j       print_col_loop

next_print_row:
    li      $v0,                4
    la      $a0,                newline
    syscall
    addi    $s3,                $s3,    1       # Next row
    j       print_row_loop

print_end:
    jr      $ra


# Inputs:
#   $a0 = x (column index)
#   $a1 = y (row index)
#   $a2 = value (new gScore)
set_g_score:
    # Calculate the index of the node in the nodes array
    lw $t0, map_width         # Load map width
    mul $t1, $a1, $t0         # t1 = y * width
    add $t1, $t1, $a0         # t1 = y * width + x

    # Calculate the address of the node
    lw $t2, node_size         # Load size of each node
    mul $t3, $t1, $t2         # t3 = (y * width + x) * node_size
    la $t4, nodes             # Base address of nodes array
    add $t4, $t4, $t3         # t4 = &nodes[y * width + x]

    # Update the gScore field of the node
    sw $a2, gScore($t4)       # Store the new gScore value at the gScore offset

    jr $ra                    # Return to caller

# Inputs:
#   $a0 = x (column index)
#   $a1 = y (row index)
# Returns:
#   $v0 = gScore (or -1 if not set)
get_g_score:
    # Calculate the index of the node in the nodes array
    lw $t0, map_width         # Load map width
    mul $t1, $a1, $t0         # t1 = y * width
    add $t1, $t1, $a0         # t1 = y * width + x

    # Calculate the address of the node
    lw $t2, node_size         # Load size of each node
    mul $t3, $t1, $t2         # t3 = (y * width + x) * node_size
    la $t4, nodes             # Base address of nodes array
    add $t4, $t4, $t3         # t4 = &nodes[y * width + x]

    # Retrieve the gScore field of the node
    lw $v0, gScore($t4)       # Load the gScore value from the gScore offset

    jr $ra                    # Return to caller

.include "..\PriorityQueue\pq.asm"