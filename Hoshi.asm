.data
########################################
##########   Common Data    ############
map_width:    .word 32
map_height:   .word 32
.eqv    gridWidth, 32
.eqv    gridHeight, 32

# Map data (0 = walkable, 1 = obstacle)
grid:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 0
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 1
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 2
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 3
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 4
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 5
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 6
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 7
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 8
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 9
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 10
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 11
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 12
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 13
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 14
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 15
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 16
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 17
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 18
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 19
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 20
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 21
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 22
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 23
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 24
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 25
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 26
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 27
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 28
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 29
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 30
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 31

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 31
goal_y:       .word 31

# Offsets for fields within the node structure
    .eqv    x, 0
    .eqv    y, 4
    .eqv    wall, 8                             # 4 bytes
    .eqv    gScore, 12
    .eqv    hScore, 16
    .eqv    fScore, 20
    .eqv    parent_x, 24
    .eqv    parent_y, 28

########################################
#############   Bit Map   ##############

    .eqv    displayWidth, 32                                            # Width of the display in units 512 / 32 = 16
    .eqv    displayHeight, 32                                           # Height of the display in units 512 / 32 = 16
    .eqv    gridCellWidth, 1                                            # Size of the display in bytes
    .eqv    gridCellHeight, 1                                           # Size of the display in bytes
    .eqv    bitmapBaseAddress, 0x10040000

colorTable:
    .word   0xFAF9F6 # White (background)  0
    .word   0x000000 # Black (background)  1
    .word   0x00ff00 # Green               2
    .word   0xff0000 # Red                 3
    .word   0xffffff # White               4
    .word   0xFFFF00 # Yellow              5
    .word   0x0000FF # Blue                6
    .word   0xFF00FF # Magenta             7
    .word   0x00FFFF # Cyan                8
    .word   0x808080 # Gray                9
    .word   0xFFA500 # Orange              10
    .word   0x800080 # Purple              11
    .word   0xA52A2A # Brown               12

########################################
############   Star Algo   #############

# Movement directions (4-way: up, right, down, left)
d4x:                .word       0, 1, 0, -1
d4y:                .word       -1, 0, 1, 0

# Or 8-way movement (includes diagonals)
d8x:                .word       0, 1, 1, 1, 0, -1, -1, -1
d8y:                .word       -1, -1, 0, 1, 1, 1, 0, -1

########################################
############   Node List   #############

nodes:          .word  0:9216                                 # 64 nodes × 32 bytes
closed_set:     .word   0:1024                                  # 1 node × 32 bytes
node_size:      .word   32                                  # Size of each node (32 bytes)
nodes_count:    .word   0                                   # Number of nodes created

########################################
#########   Priority Queue   ###########

heap:           .space  16000                                # 100-node heap
heapSize:       .word   0                                   # Current Number of nodes in the heap
heap_capacity:  .word   1000                                 # Maximum number of nodes in the heap = 1200 / 12
extracted_node: .space  16                                  # 4B x + 4B y + 4B parent + 4B fScore

########################################
#########   Messages & String   ########
########################################

# priority queue messages
msg_heap_full:  .asciiz "Heap is full. Cannot insert.\n"
msg_heap_empty: .asciiz "Heap is empty.\n"
msg_extract:    .asciiz "Extracted node: "
popcorn:        .asciiz "pop pop pop.....\n"

# Node messages
node_str:       .asciiz "Node ["
wall_str:       .asciiz "] Wall: "

# Star algo messages
msg_path_found:    .asciiz     "Path found!\n"
msg_no_path:       .asciiz     "No path exists.\n"

#strings
str_space:      .asciiz " "
newline:        .asciiz "\n"
msg_coma:          .asciiz ","

.text

main:
    # Initialize stack pointer
    la      $sp,                    0x7FFFEFFC

    # Draw grid
    jal     clearScreen
    la      $a0,                grid
    li      $a1,                0
    li      $a2,                1
    jal     drawGrid

    # draw start and goal nodes
    lw      $a0,                start_x
    lw      $a1,                start_y
    li      $a2,                12
    jal drawGridNode

    lw      $a0,                goal_x
    lw      $a1,                goal_y
    li      $a2,                12
    jal drawGridNode

        # 3. Add delay
    li $a0, 10        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
    syscall

    # Call A* algorithm
    jal     a_star


    # Exit program
    li      $v0,                    10
    syscall

########################################
#############   Bit Map   ##############

clearScreen:
    li      $t0,                bitmapBaseAddress
    li      $t1,                displayWidth
    mul     $t1,                $t1,                displayHeight
    sll     $t1,                $t1,                2
    add     $t1,                $t1,                bitmapBaseAddress
    li      $t2,                0x808080                                # Black color
clearLoop:
    sw      $t2,                0($t0)
    addi    $t0,                $t0,                4
    blt     $t0,                $t1,                clearLoop
    
    #delay
    li $a0, 10        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
    syscall

    jr      $ra
    # $a0 = base address , $a1 = free space     , $a2 = wall color
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
    li $a0, 5        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
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

calculateAddress:
    li      $v0,                bitmapBaseAddress

    mul     $t0,                $a1,                displayWidth
    add     $t0,                $t0,                $a0
    sll     $t0,                $t0,                2
    add     $v0,                $v0,                $t0
    jr      $ra

getColor:
    la      $t0,                colorTable
    sll     $t1,                $a2,                2
    add     $t0,                $t0,                $t1
    lw      $v1,                0($t0)
    jr      $ra

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

########################################
##############    Hoshi   ##############

a_star:
    # Save return address and preserved registers
    addi    $sp,                    $sp,                -16
    sw      $ra,                    0($sp)
    sw      $s0,                    4($sp)
    sw      $s1,                    8($sp)
    sw      $s2,                    12($sp)

        # draw start and goal nodes
    lw      $a0,                start_x
    lw      $a1,                start_y
    li      $a2,                12
    jal drawGridNode
    
    lw      $a0,                goal_x
    lw      $a1,                goal_y
    li      $a2,                12
    jal drawGridNode

    # Initialize
    jal     initialize_nodes

    # Add start node to open set
    lw      $a0,                    start_x                                 # x
    lw      $a1,                    start_y                                 # y
    li      $t0,                    0                                       # g_score = 0

    # Set g_score for start node
    move    $a2,                    $t0
    jal     set_g_score

    # Calculate h_score for start node
    lw      $a0,                    start_x
    lw      $a1,                    start_y
    lw      $a2,                    goal_x
    lw      $a3,                    goal_y

    jal     manhattan_heuristic
    move    $t1,                    $v0                                     # h_score

    # Calculate f_score = g_score + h_score
    # add     $t2,                    $t0,                $t1                 # f_score

    # Push start node to open set
    lw      $a0,                    start_x                                 # x
    lw      $a1,                    start_y                                 # y
    move    $a2,                    $zero                                   # parent (none for start)
    move    $a3,                    $t1                                     # f_score
    jal     push                                                            # Push node into the priority queue


    # Main loop
a_star_loop:
    # Check if open set is empty
    la      $t0,                    heapSize
    lw      $t1,                    0($t0)
    beqz    $t1,                    no_path_found

    # Pop node with lowest f_score
    jal     pop

    # Check if popped node is goal
    la      $t0,                    extracted_node
    lw      $t1,                    0($t0)                                  # x
    lw      $t2,                    4($t0)                                  # y

    # Check if popped node is goal
    lw      $t3,                    goal_x
    lw      $t4,                    goal_y
    bne     $t1,                    $t3,                not_goal
    bne     $t2,                    $t4,                not_goal

    # Found path to goal!
    j       path_found

not_goal:
    # Add current node to closed set
    move    $a0,                    $t1                                     # x
    move    $a1,                    $t2                                     # y
    move    $s0,                    $t1                                     # Save current x
    move    $s1,                    $t2                                     # Save current y
    jal     add_to_closed_set

    # Draw current node
    move    $a0,                    $s0                                     # x
    move    $a1,                    $s1                                     # y
    li      $a2,                    5                           # color     # yellow
    jal drawGridNode
        #delay
    li $a0, 50        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
    syscall

    # Process neighbors

    # Get g_score of current node
    move    $a0,                    $s0
    move    $a1,                    $s1
    jal     get_g_score
    move    $s2,                    $v0                                     # Save g_score

    # Process each neighbor
    li      $s5,                    0                                       # Direction index

process_neighbors_loop:
    # Check if we've processed all directions
    li      $t1,                    4                                       # 4 directions
    beq     $s5,                    $t1,                a_star_loop

    # Calculate neighbor coordinates
    la      $t2,                    d4x
    la      $t3,                    d4y
    sll     $t4,                    $s5,                2                   # direction * 4
    add     $t2,                    $t2,                $t4
    add     $t3,                    $t3,                $t4
    lw      $t2,                    0($t2)                                  # dx
    lw      $t3,                    0($t3)                                  # dy

    add     $t4,                    $s0,                $t2                 # neighbor_x = current_x + dx
    add     $t5,                    $s1,                $t3                 # neighbor_y = current_y + dy

    # Save neighbor coordinates
    move    $s3,                    $t4                                     # x
    move    $s4,                    $t5                                     # y
    move    $a0,                    $t4
    move    $a1,                    $t5

    # Check if valid position
    jal     is_valid_position
    beqz    $v0,                    next_neighbor

    # Check if in closed set
    move    $a0,                    $s3
    move    $a1,                    $s4
    jal     is_in_closed_set
    bnez    $v0,                    next_neighbor

    # Calculate tentative g_score
    addi    $t6,                    $s2,                1                   # tentative_g = current_g + 10 (cost)

    # Update g_score
    move    $a0,                    $s3
    move    $a1,                    $s4
    move    $a2,                    $t6
    jal     set_g_score

    # Calculate h_score
    move    $a0,                    $s3
    move    $a1,                    $s4
    lw      $a2,                    goal_x
    lw      $a3,                    goal_y

    jal     manhattan_heuristic
    move    $t7,                    $v0                                     # h_score

    # Calculate f_score = g_score + h_score
    add     $t8,                    $t6,                $t7                 # f_score

    # Generate parent index
    sll     $t9,                    $s1,                16                  # parent_y << 16
    or      $t9,                    $t9,                $s0                 # (parent_y << 16) | parent_x

    la      $t0,                    nodes                                   # Base node address
    la      $t1,                    grid                                # Map data pointer
    lw      $t3,                    map_width                               # Grid dimensions

    mul     $t2,                    $s4,                $t3                 # t0 = row * map_width
    add     $t2,                    $t2,                $s3
    lw      $t4,                    node_size
    mul     $t2,                    $t4,                $t2                 # t0 = (row * map_width + col) * 4
    add     $t2,                    $t2,                $t0                 # t1 = base + (row * map_width + col) * 4  -> map address

    mul     $t3,                    $s4,                $t3
    add     $t3,                    $t3,                $s3
    sll     $t3,                    $t3,                2                   # t3 = (row * map_width + col) * 4
    add     $t3,                    $t1,                $t3                 # t3 = base + (row * map_width + col) * node_size -> node address

    # Store coordinates
    sw      $s3,                    x($t2)                                  # Store Column index in node
    sw      $s4,                    y($t2)                                  # Store row index in node

    # Store wall status
    lw      $t5,                    0($t3)                                  # Get map value
    sw      $t5,                    wall($t2)                               # Store wall status in node

    # The star req
    sw      $t6,                    gScore($t2)                             # Initialize gScore to -1 (unvisited) except start node:   (still will add it)
    sw      $t7,                    hScore($t2)                             # Initialize hScore to 0 (or any other value)
    sw      $t8,                    fScore($t2)                             # Initialize fScore to 2 (or any other value)
    sw      $s0,                    parent_x($t2)                           # Initialize parent_x to 0 (or any other value)
    sw      $s1,                    parent_y($t2)                           # Initialize parent_y to 0 (or any other value)

    # skip start node  (yeah ...... ai wrote this ..... very very very helpful) lol
    # if ($s3 == start_x && $s4 == start_y) {
    #     j       next_neighbor
    # }  
    
    # draw current node
    move    $a0,                    $s0                                     # x
    move    $a1,                    $s1                                     # y
    li      $a2,                    9                                       # color
    jal drawGridNode

    #delay
    li $a0, 10        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
    syscall

    # Push to open set
    move    $a0,                    $s3                                     # x
    move    $a1,                    $s4                                     # y
    move    $a2,                    $t9                                     # parent
    move    $a3,                    $t8                                     # f_score

    jal     push

next_neighbor:

    addi    $s5,                    $s5,                1                   # Next direction
    j       process_neighbors_loop


a_star_exit:
    # Restore return address and preserved registers
    lw      $ra,                    0($sp)
    lw      $s0,                    4($sp)
    lw      $s1,                    8($sp)
    lw      $s2,                    12($sp)
    addi    $sp,                    $sp,                16
    jr      $ra


    # a0 = x, a1 = y
    # Returns v0 = 1 if valid, 0 if invalid
is_valid_position:
    # Save return address
    addi    $sp,                    $sp,                -4                  # useless
    sw      $ra,                    0($sp)

    # Check if within bounds
    lw      $t0,                    map_width
    lw      $t1,                    map_height

    # Check x bounds
    bltz    $a0,                    invalid_position
    bge     $a0,                    $t0,                invalid_position

    # Check y bounds
    bltz    $a1,                    invalid_position
    bge     $a1,                    $t1,                invalid_position

    # Check if obstacle
    la      $t2,                    grid
    mul     $t3,                    $a1,                $t0                 # y * width
    add     $t3,                    $t3,                $a0                 # y * width + x
    sll     $t3,                    $t3,                2                   # (y * width + x) * 4
    add     $t2,                    $t2,                $t3                 # &grid[y * width + x]
    lw      $t4,                    0($t2)
    bnez    $t4,                    invalid_position                        # If grid[y][x] != 0, position is obstacle

    li      $v0,                    1
    j       is_valid_exit

invalid_position:
    li      $v0,                    0

is_valid_exit:
    # Restore return address and return
    lw      $ra,                    0($sp)
    addi    $sp,                    $sp,                4
    jr      $ra

no_path_found:
    # Print "No path exists" message
    la      $a0,                    msg_no_path
    li      $v0,                    4                                       # Print string syscall
    syscall
    j       a_star_exit

path_found:

    # Draw path from goal to start
    lw     $s5,                    goal_x
    lw     $s6,                    goal_y

    path_found_loop:
    lw     $s0,                    start_x
    lw     $s1,                    start_y
    # Check if we reached the start node
    beq     $s5,                    $s0,                path_found_end
    
    nono:

    # print current node
    li $v0,                    4                                       # Print string syscall
    la $a0,                    newline
    syscall

    li $v0,                    1
    move     $a0,                    $s5                                     # x
    syscall

    li $v0,                    1
    move     $a0,                    $s6                                     # y
    syscall

    li $v0,                    4                                       # Print string syscall
    la $a0,                    newline
    syscall

# Draw the current node
    li      $a2, 3                   # Set color (e.g., green for the path)
    move    $a0, $s5                 # x-coordinate
    move    $a1, $s6                 # y-coordinate

    jal     drawGridNode   
    
        #delay
    li $a0, 10        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
    syscall          # Draw the node

    # Get the parent coordinates of the current node
    la      $s0,                nodes                       # Base node address
    la      $s1,                grid                    # Map data pointer
    lw      $s2,                map_width                   # Grid dimensions
    lw      $s3,                map_height
    
    mul     $t0,                $s6,            $s2         # t0 = y * map_width
    add     $t0,                $t0,            $s5         # t0 = y * map_width + x
    sll     $t0,                $t0,            2           # t0 = (y * map_width + x) * 4
    add     $t1,                $s1,            $t0         # t1 = base + (row * map_width + x) * 4  -> map address

    mul     $t2,                $s6,            $s2
    add     $t2,                $t2,            $s5
    lw      $t3,                node_size
    mul     $t2,                $t2,            $t3         # × node_size
    add     $t2,                $s0,            $t2         # t3 = base + (row * map_width + col) * node_size -> node address

    lw      $s5,                parent_x($t2)                   # Load parent_x
    lw      $s6,                parent_y($t2)                   # Load parent_y

    # Repeat the loop
    j       path_found_loop

    path_found_end:
    bne     $s6,                    $s1,                nono

    lw   $a0,                    goal_x                                    # x
    lw   $a1,                    goal_y                                    # y
    li   $a2,                    2                                       # green
    jal drawGridNode
    
    lw $a0, start_x
    lw $a1, start_y
    li $a2, 8
    jal drawGridNode

    # Print "Path found" message
    jal     print_node_grid
    la      $a0,                    msg_path_found
    li      $v0,                    4                                       # Print string syscall
    syscall
    j       a_star_exit
is_in_closed_set:
    # Check if the node is in the closed set
    la      $t0,                    closed_set
    lw      $t1,                    map_width
    mul     $t2,                    $a1,                $t1                 # y * width
    add     $t2,                    $t2,                $a0                 # y * width + x
    sll     $t2,                    $t2,                2                   # (y * width + x) * 4
    add     $t0,                    $t0,                $t2                 # &closed_set[y * width + x]
    lw      $t3,                    0($t0)                                  # Load closed set value
    beqz    $t3,                    not_in_closed_set                       # If closed set value is 0, not in closed set
    
    li      $v0,                    1                                       # In closed set
    jr      $ra
not_in_closed_set:
    li      $v0,                    0                                       # Not in closed set
    jr      $ra

    # a0 = x, a1 = y
add_to_closed_set:
    # Calculate index in closed_set
    lw      $t0,                    map_width
    mul     $t1,                    $a1,                $t0                 # y * width
    add     $t1,                    $t1,                $a0                 # y * width + x
    sll     $t1,                    $t1,                2                   # (y * width + x) * 4
    la      $t2,                    closed_set
    add     $t2,                    $t2,                $t1                 # &closed_set[y * width + x]
    li      $t3,                    1
    sw      $t3,                    0($t2)                                  # Mark as closed

    jr      $ra

########################################
#########   Heuristic Calc   ###########

manhattan_heuristic:            # Manhattan distance (|x1 - x2| + |y1 - y2|)
    # Inputs:
    #   $a0: current.x
    #   $a1: current.y
    #   $a2: goal.x
    #   $a3: goal.y
    # Output:
    #   $v0: Manhattan distance

    sub     $t4, $a0, $a2     # t4 = current.x - goal.x
    bltz    $t4, neg_x        # If t4 < 0, branch to neg_x
x_done:
    sub     $t5, $a1, $a3     # t5 = current.y - goal.y
    bltz    $t5, neg_y        # If t5 < 0, branch to neg_y
y_done:
    add     $v0, $t4, $t5     # v0 = |current.x - goal.x| + |current.y - goal.y|
    
    jr      $ra               # Return to caller
    
neg_x:
    sub     $t4, $zero, $t4   # t4 = zero - t4 (absolute value)
    j       x_done            # Continue with y calculation
    
neg_y:
    sub     $t5, $zero, $t5   # t5 = zero - t5 (absolute value)
    j       y_done            # Continue with result calculation



euclidean_heuristic:
    # Inputs:
    #   $a0: current.x
    #   $a1: current.y
    #   $a2: goal.x
    #   $a3: goal.y
    # Output:
    #   $v0: Euclidean distance (rounded to nearest integer)

    # Calculate (x1 - x2)
    sub     $t4, $a0, $a2
    
    # Calculate (y1 - y2)
    sub     $t5, $a1, $a3
    
    # Convert (x1-x2) to float
    mtc1    $t4, $f1
    cvt.s.w $f1, $f1
    
    # Convert (y1-y2) to float
    mtc1    $t5, $f2
    cvt.s.w $f2, $f2
    
    # Square both
    mul.s   $f3, $f1, $f1     # (x1-x2)^2
    mul.s   $f4, $f2, $f2     # (y1-y2)^2
    
    # Add
    add.s   $f5, $f3, $f4     # (x1-x2)^2 + (y1-y2)^2
    
    # Take square root
    sqrt.s  $f0, $f5          # Result in $f0
    
    # Convert float result to integer (round to nearest)
    cvt.w.s $f0, $f0          # Convert to word format
    mfc1    $v0, $f0          # Move to integer register for return
    
    # Restore return address and return
    jr      $ra               # Return to caller


########################################
#########   Priority Queue   ###########

push:
    la      $t0,                heapSize
    lw      $t1,                0($t0)
    la      $t2,                heap_capacity
    lw      $t3,                0($t2)
    bge     $t1,                $t3,                push_full

    la      $t4,                heap
    sll     $t5,                $t1,                4
    add     $t4,                $t4,                $t5
    sw      $a0,                0($t4)
    sw      $a1,                4($t4)
    sw      $a2,                8($t4)
    sw      $a3,                12($t4)

    addi    $t1,                $t1,                1
    sw      $t1,                0($t0)
    addi    $t3,                $t1,                -1
    j       bubble_up

bubble_up:
    beq     $t3,                $zero,              bubble_up_end
    addi    $t4,                $t3,                -1
    srl     $t4,                $t4,                1
    la      $t5,                heap
    sll     $t6,                $t4,                4
    add     $t5,                $t5,                $t6
    lw      $t7,                12($t5)
    la      $t8,                heap
    sll     $t9,                $t3,                4
    add     $t8,                $t8,                $t9
    lw      $t0,                12($t8)
    bge     $t0,                $t7,                bubble_up_end

    # Swap using $t registers
    lw      $t0,                0($t5)
    lw      $t1,                0($t8)
    sw      $t0,                0($t8)
    sw      $t1,                0($t5)
    lw      $t0,                4($t5)
    lw      $t1,                4($t8)
    sw      $t0,                4($t8)
    sw      $t1,                4($t5)
    lw      $t0,                8($t5)
    lw      $t1,                8($t8)
    sw      $t0,                8($t8)
    sw      $t1,                8($t5)
    lw      $t0,                12($t5)
    lw      $t1,                12($t8)
    sw      $t0,                12($t8)
    sw      $t1,                12($t5)

    move    $t3,                $t4
    j       bubble_up

bubble_up_end:
    jr      $ra

pop:
    la      $t0,                heapSize
    lw      $t1,                0($t0)
    beqz    $t1,                pop_failed

    la      $t2,                heap
    lw      $t3,                0($t2)
    lw      $t4,                4($t2)
    lw      $t5,                8($t2)
    lw      $t6,                12($t2)
    la      $t7,                extracted_node
    sw      $t3,                0($t7)
    sw      $t4,                4($t7)
    sw      $t5,                8($t7)
    sw      $t6,                12($t7)

    addi    $t1,                $t1,                -1
    sw      $t1,                0($t0)
    beqz    $t1,                pop_end

    la      $t2,                heap
    sll     $t3,                $t1,                4
    add     $t4,                $t2,                $t3
    lw      $t7,                0($t4)
    lw      $t8,                4($t4)
    lw      $t9,                8($t4)
    lw      $t0,                12($t4)
    sw      $t7,                0($t2)
    sw      $t8,                4($t2)
    sw      $t9,                8($t2)
    sw      $t0,                12($t2)
    li      $t3,                0
    j       bubble_down

bubble_down:
    sll     $t4,                $t3,                1
    addi    $t5,                $t4,                1
    addi    $t6,                $t4,                2
    move    $t7,                $t3                                 # Candidate index

    la      $t8,                heapSize
    lw      $t9,                0($t8)
    bgt     $t5,                $t9,                pop_end
    bgt     $t6,                $t9,                pop_end
    la      $t0,                heap
    sll     $t1,                $t5,                4
    add     $t0,                $t0,                $t1
    lw      $t2,                12($t0)                             # Left child fScore
    la      $t0,                heap
    sll     $t1,                $t6,                4
    add     $t0,                $t0,                $t1
    lw      $t3,                12($t0)                             # Right child fScore
    blt     $t2,                $t3,                check_left
    la      $t0,                heap
    sll     $t7,                $t7,                4
    add     $t7,                $t0,                $t7
    lw      $t2,                12($t7)                             # node fScore
    blt     $t2,                $t3,                pop_end
    # Swap using $t registers
    sll     $t6,                $t6,                4
    add     $t6,                $t0,                $t6
    lw      $t0,                0($t6)
    lw      $t1,                0($t7)
    sw      $t0,                0($t7)
    sw      $t1,                0($t6)
    lw      $t0,                4($t6)
    lw      $t1,                4($t7)
    sw      $t0,                4($t7)
    sw      $t1,                4($t6)
    lw      $t0,                8($t6)
    lw      $t1,                8($t7)
    sw      $t0,                8($t7)
    sw      $t1,                8($t6)
    lw      $t0,                12($t6)
    lw      $t1,                12($t7)
    sw      $t0,                12($t7)
    sw      $t1,                12($t6)


check_left:
    la      $t0,                heap
    sll     $t7,                $t7,                4
    add     $t7,                $t0,                $t7
    lw      $t3,                12($t7)                             # node fScore
    blt     $t3,                $t2,                pop_end
    # Swap using $t registers
    sll     $t5,                $t5,                4
    add     $t5,                $t0,                $t5
    lw      $t0,                0($t5)
    lw      $t1,                0($t7)
    sw      $t0,                0($t7)
    sw      $t1,                0($t5)
    lw      $t0,                4($t5)
    lw      $t1,                4($t7)
    sw      $t0,                4($t7)
    sw      $t1,                4($t5)
    lw      $t0,                8($t5)
    lw      $t1,                8($t7)
    sw      $t0,                8($t7)
    sw      $t1,                8($t5)
    lw      $t0,                12($t5)
    lw      $t1,                12($t7)
    sw      $t0,                12($t7)
    sw      $t1,                12($t5)

pop_end:
    jr      $ra

pop_failed:
    li      $t0,                -1
    sw      $t0,                0($a0)
    sw      $t0,                4($a0)
    sw      $t0,                8($a0)
    sw      $t0,                12($a0)
    jr      $ra

    # Printing routines remain unchanged but ensure no saved registers are used.

push_full:
    # Print "Heap is full" message
    la      $a0,                msg_heap_full
    li      $v0,                4                                   # Print string syscall
    syscall
    jr      $ra

    # === PRINTING ROUTINES ===

print_heap:
    # Load heapSize and base address of heap
    la      $t0,                heapSize
    lw      $t1,                0($t0)                              # t1 = heapSize
    la      $t2,                heap

    beqz    $t1,                print_heap_empty                    # If heapSize == 0, print empty message

    li      $t3,                0                                   # index = 0
print_heap_loop:
    bge     $t3,                $t1,                print_heap_end  # Exit loop when index >= heapSize
    # Calculate node address: index * 16
    mul     $t4,                $t3,                16
    add     $t5,                $t2,                $t4

    # Print x at offset 0
    lw      $a0,                0($t5)
    li      $v0,                1                                   # Print integer syscall
    syscall

    # Print comma and space
    la      $a0,                msg_coma
    li      $v0,                4
    syscall

    # Print y at offset 4
    lw      $a0,                4($t5)
    li      $v0,                1
    syscall

    # Print comma and space
    la      $a0,                msg_coma
    li      $v0,                4
    syscall

    # Print parent at offset 8
    lw      $a0,                8($t5)
    li      $v0,                1
    syscall

    # Print comma and space
    la      $a0,                msg_coma
    li      $v0,                4
    syscall

    # Print fScore at offset 12
    lw      $a0,                12($t5)
    li      $v0,                1
    syscall

    # Print a newline
    la      $a0,                newline
    li      $v0,                4
    syscall

    # Increment index and loop
    addi    $t3,                $t3,                1
    j       print_heap_loop
print_heap_end:
    jr      $ra

print_heap_empty:
    la      $a0,                msg_heap_empty
    li      $v0,                4
    syscall
    jr      $ra

print_EX_node:
    la      $t0,                extracted_node                      # Extracted node structure (16 bytes)

    # Print x
    lw      $a0,                0($t0)
    li      $v0,                1
    syscall

    la      $a0,                msg_coma
    li      $v0,                4
    syscall

    # Print y
    lw      $a0,                4($t0)
    li      $v0,                1
    syscall

    la      $a0,                msg_coma
    li      $v0,                4
    syscall

    # Print parent
    lw      $a0,                8($t0)
    li      $v0,                1
    syscall

    la      $a0,                msg_coma
    li      $v0,                4
    syscall

    # Print fScore
    lw      $a0,                12($t0)
    li      $v0,                1
    syscall

    # Newline
    la      $a0,                newline
    li      $v0,                4
    syscall

    jr      $ra

########################################
############   Node List   #############

nodeListMain:

    jal     initialize_nodes                                # Create node grid from map
    jal     print_node_grid     
    
                                # Verification print

    li      $v0,                10                          # Exit
    syscall

initialize_nodes:
    la      $s0,                nodes                       # Base node address
    la      $s1,                grid                    # Map data pointer
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

########################################
#########   Print Something   ##########
