.include "..\node\node_data.asm"

.text

# main:

#     # jal     initialize_nodes                                # Create node grid from map
#     # jal     print_node_grid     

#     li      $v0,                10                          # Exit
#     syscall

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
    add     $t3,                $s0,            $t2         # t4 = base + (row * map_width + col) * node_size -> node address

    # Store coordinates
    sw      $s5,                x($t3)                      # Store row index in node
    sw      $s4,                y($t3)                      # Store column index in node

    # Store wall status
    lw      $t5,                0($t1)                      # Get map value
    sw      $t5,                wall($t3)                   # Store wall status in node

    # The star req
    li      $t6,                -1      
    sw      $t6,                gScore($t3)                 # Initialize gScore to -1 (unvisited) except start node:   (still will add it) 
    
    

    sw      $t6,                hScore($t3)                 # Initialize hScore to 0 (or any other value)
    add     $t6,                $t6,            $t6
    sw      $t6,                fScore($t3)                 # Initialize fScore to 2 (or any other value)
    li      $t6,                0
    sw      $t6,                parent_x($t3)               # Initialize parent_x to 0 (or any other value)
    li      $t6,                0
    sw      $t6,                parent_y($t3)               # Initialize parent_y to 0 (or any other value)


    lw      $t6,                node_size

    # Increment counters
    addi    $s5,                $s5,            1           # Next column
    lw      $t7,                nodes_count
    addi    $t7,                $t7,            1
    sw      $t7,                nodes_count

    j       col_loop

next_row:
    li      $v0,                4
    la      $a0,                str_newline
    syscall
    addi    $s4,                $s4,            1           # Increment row counter
    j       row_loop

_done:
    jr      $ra

print_node_grid:
    la      $t0,                nodes
    lw      $t1,                nodes_count
    li      $t2,                0

print_loop:
    bge     $t2,                $t1,            print_end

    # Calculate node address
    lw      $t3,                node_size
    mul     $t4,                $t2,            $t3
    add     $t5,                $t0,            $t4

    # Print coordinates and wall status
    li      $v0,                4
    la      $a0,                node_str
    syscall

    li      $v0,                1
    lw      $a0,                0($t5)                      # x
    syscall

    li      $v0,                4
    la      $a0,                comma
    syscall

    li      $v0,                1
    lw      $a0,                4($t5)                      # y
    syscall

    li      $v0,                4
    la      $a0,                wall_str
    syscall

    li      $v0,                1
    lw      $a0,                8($t5)                      # wall
    syscall

    li      $v0,                4
    la      $a0,                newline
    syscall

    addi    $t2,                $t2,            1
    j       print_loop

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

# .include "PriorityQueue\pq.asm"
# .include "map\MII.asm"