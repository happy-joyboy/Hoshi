.data
str_space:      .asciiz " "
str_newline:    .asciiz "\n"

nodes:          .space  3200                                 # 9 nodes ? 36 bytes
node_size:      .word   32                                  # Size of each node (36 bytes)
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
comma:          .asciiz ","
wall_str:       .asciiz "] Wall: "
newline:        .asciiz "\n"

# Add to existing strings
hscore_str:    .asciiz " hScore: "

.text
.globl main

main:
    jal initialize_nodes
    jal calculate_all_heuristics  # New function to apply heuristic
    jal print_node_grid_with_h     # Modified print function
    li $v0, 10
    syscall

initialize_nodes:
    la      $s0,                nodes                       # Base node address
    la      $s1,                map_data                    # Map data pointer
    lw      $s2,                map_width                   # Grid dimensions
    lw      $s3,                map_height

    # lw $t0, nodes                   # Load base address of nodes
    # lw $t5, map_data

    # lw $t0, map_height               # Load map height
    # lw $t1, map_width                # Load map width

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
    mul     $t2,                $t2,            $t3         # ? node_size
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
    li      $t6,                0
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


# New function: Calculate heuristics for all nodes
calculate_all_heuristics:
    # Find goal node
    lw $a0, goal_x
    lw $a1, goal_y
    jal find_node
    move $s6, $v0  # Store goal node address in $s6

    # Loop through all nodes
    la $s0, nodes
    lw $s1, nodes_count
    li $s2, 0

    heuristic_loop:
        bge $s2, $s1, heuristic_done
        
        # Get current node address
        lw $t0, node_size
        mul $t1, $s2, $t0
        add $a0, $s0, $t1  # Current node address
        
        # Calculate heuristic
        move $a1, $s6       # Goal node address
        jal manhattan_heuristic
        
        # Store result in node
        li $s4, 0
        addi $s4, $v0, 0
        sw $s4, hScore($a0)
        
        addi $s2, $s2, 1
        j heuristic_loop

heuristic_done:
    jr $ra

# Helper function to find node by coordinates
# Input: $a0 = x, $a1 = y
# Output: $v0 = node address
find_node:
    la $t0, nodes
    lw $t1, nodes_count
    li $t2, 0

    find_loop:
        bge $t2, $t1, not_found
        
        lw $t3, node_size
        mul $t4, $t2, $t3
        add $t5, $t0, $t4
        
        lw $t6, x($t5)
        lw $t7, y($t5)
        
        beq $t6, $a0, check_y
        j next_node
        
    check_y:
        beq $t7, $a1, found_node
        
    next_node:
        addi $t2, $t2, 1
        j find_loop
        
    found_node:
        move $v0, $t5
        jr $ra
        
    not_found:
        li $v0, 0
        jr $ra

# Modified print function to show hScores
print_node_grid_with_h:
    la $t0, nodes
    lw $t1, nodes_count
    li $t2, 0

    print_loop_h:
        bge $t2, $t1, print_end_h

        lw $t3, node_size
        mul $t4, $t2, $t3
        add $t5, $t0, $t4

        # Print coordinates and wall status
        li $v0, 4
        la $a0, node_str
        syscall

        li $v0, 1
        lw $a0, x($t5)
        syscall

        li $v0, 4
        la $a0, comma
        syscall

        li $v0, 1
        lw $a0, y($t5)
        syscall

        li $v0, 4
        la $a0, wall_str
        syscall

        li $v0, 1
        lw $a0, wall($t5)
        syscall

        # Print hScore
        li $v0, 4
        la $a0, hscore_str
        syscall

        li $v0, 1
        lw $a0, hScore($t5)
        syscall

        li $v0, 4
        la $a0, newline
        syscall

        addi $t2, $t2, 1
        j print_loop_h

print_end_h:
    jr $ra

.include "h_calc.asm"
.include "map\MII.asm"
.include "node\Node_list.asm"