.text
nodeListMain:

    jal     initialize_nodes                                                        # Create node grid from map

    # Verification print

    li      $v0,                        10                                          # Exit
    syscall

initialize_nodes:
    addi    $sp,                        $sp,            -4
    sw      $ra,                        0($sp)                                      # Save return address
    jal     clearScreen
    la      $s0,                        nodes                                       # Base node address
    la      $s1,                        map_data                                    # Map data pointer
    lw      $s2,                        map_width                                   # Grid dimensions
    lw      $s3,                        map_height

    li      $s4,                        0                                           # Row counter (y)
row_loop:
    beq     $s4,                        $s3,            _done                       # If row counter equals row count, exit loop
    li      $s5,                        0                                           # Column counter (x)

col_loop:
    beq     $s5,                        $s2,            next_row                    # If column counter equals column count, go to next row

    # calc address of the node & map
    mul     $t0,                        $s4,            $s2                         # t0 = row * map_width
    add     $t0,                        $t0,            $s5                         # t0 = row * map_width + col
    sll     $t0,                        $t0,            2                           # t0 = (row * map_width + col) * 4
    add     $t1,                        $s1,            $t0                         # t1 = base + (row * map_width + col) * 4  -> map address

    mul     $t2,                        $s4,            $s2
    add     $t2,                        $t2,            $s5
    lw      $t3,                        node_size
    mul     $t2,                        $t2,            $t3                         # × node_size
    add     $t2,                        $s0,            $t2                         # t3 = base + (row * map_width + col) * node_size -> node address

    # Store coordinates
    sw      $s5,                        x($t2)                                      # Store Column index in node
    sw      $s4,                        y($t2)                                      # Store row index in node

    # Store wall status
    lw      $t5,                        0($t1)                                      # Get map value
    sw      $t5,                        wall($t2)                                   # Store wall status in node


    # The star req
    li      $t6,                        -1
    sw      $t6,                        gScore($t2)                                 # Initialize gScore to -1 (unvisited) except start node:   (still will add it)
    li      $t6,                        0
    sw      $t6,                        hScore($t2)                                 # Initialize hScore to 0 (or any other value)
    add     $t6,                        $t6,            $t6
    sw      $t6,                        fScore($t2)                                 # Initialize fScore to 2 (or any other value)
    li      $t6,                        0
    sw      $t6,                        parent_x($t2)                               # Initialize parent_x to 0 (or any other value)
    li      $t6,                        0
    sw      $t6,                        parent_y($t2)                               # Initialize parent_y to 0 (or any other value)


    move    $a0,                        $s5
    move    $a1,                        $s4
    move    $a2,                        $t5

    # Call drawGridNode to draw the node on the screen
    jal     drawGridNode



    # Increment counters
    addi    $s5,                        $s5,            1                           # Next column
    lw      $t7,                        nodes_count
    addi    $t7,                        $t7,            1
    sw      $t7,                        nodes_count

    j       col_loop

next_row:
    addi    $s4,                        $s4,            1                           # Increment row counter
    j       row_loop

_done:
    lw      $ra,                        0($sp)                                      # Restore return address
    addi    $sp,                        $sp,            4                           # Restore stack pointer
    jr      $ra
printSolution:
    addi    $sp,                        $sp,            -4
    sw      $ra,                        0($sp)
    # print start & goal nodes                                   # Save return address
    lw      $a0,                        start_x
    lw      $a1,                        start_y
    li      $a2,                        2
    jal     drawGridNode
    lw      $a0,                        goal_x
    lw      $a1,                        goal_y
    li      $a2,                        3
    jal     drawGridNode
    li      $a0,                        1000                                        # Delay time in milliseconds (e.g., 500ms)
    li      $v0,                        32                                          # MARS syscall for sleep
    syscall

printVisitedNodes:                                                                  # Save return address
    la      $s0,                        nodes                                       # Base node address
    lw      $s1,                        map_width                                   # Grid width
    lw      $s2,                        map_height                                  # Grid height
    li      $s3,                        0                                           # Row counter (y)
printVisitedNodes_row_loop:
    beq     $s3,                        $s2,            constructPath
    li      $s4,                        0                                           # Column counter (x)

printVisitedNodes_col_loop:
    beq     $s4,                        $s1,            printVisitedNodes_next_row
    # skip start & goal nodes
    lw      $t0,                        start_x
    lw      $t1,                        start_y
    beq     $s4,                        $t0,            check_y_start               # Check if current x matches start_x
    j       check_goal
check_y_start:
    beq     $s3,                        $t1,            printVisitedNodes_next_col  # If both x and y match start position, skip
check_goal:
    lw      $t0,                        goal_x
    lw      $t1,                        goal_y
    beq     $s4,                        $t0,            check_y_goal                # Check if current x matches goal_x
    j       continue_print
check_y_goal:
    beq     $s3,                        $t1,            printVisitedNodes_next_col  # If both x and y match goal position, skip
continue_print:

    # Calculate current node address
    mul     $t0,                        $s3,            $s1                         # row * width
    add     $t0,                        $t0,            $s4                         # + column
    lw      $t1,                        node_size
    mul     $t0,                        $t0,            $t1                         # × node_size
    add     $t0,                        $s0,            $t0                         # base + offset
    lw      $a0,                        gScore($t0)                                 # Print gScore
    beq     $a0,                        -1,             printVisitedNodes_next_col  # If gScore is -1, skip printing the rest

    move    $a0,                        $s4
    move    $a1,                        $s3
    li      $a2,                        4

    jal     drawGridNode
printVisitedNodes_next_col:
    addi    $s4,                        $s4,            1                           # Next column
    j       printVisitedNodes_col_loop

printVisitedNodes_next_row:
    addi    $s3,                        $s3,            1                           # Next row
    j       printVisitedNodes_row_loop

constructPath:
    
    lw      $ra,                        0($sp)                                      # Restore return address
    addi    $sp,                        $sp,            4                           # Restore stack pointer
    jr      $ra


    # Inputs:
    #   $a0 = x (column index)
    #   $a1 = y (row index)
    #   $a2 = value (new gScore)
set_g_score:
    # Calculate the index of the node in the nodes array
    lw      $t0,                        map_width                                   # Load map width
    mul     $t1,                        $a1,            $t0                         # t1 = y * width
    add     $t1,                        $t1,            $a0                         # t1 = y * width + x

    # Calculate the address of the node
    lw      $t2,                        node_size                                   # Load size of each node
    mul     $t3,                        $t1,            $t2                         # t3 = (y * width + x) * node_size
    la      $t4,                        nodes                                       # Base address of nodes array
    add     $t4,                        $t4,            $t3                         # t4 = &nodes[y * width + x]

    # Update the gScore field of the node
    sw      $a2,                        gScore($t4)                                 # Store the new gScore value at the gScore offset

    jr      $ra                                                                     # Return to caller

    # Inputs:
    #   $a0 = x (column index)
    #   $a1 = y (row index)
    # Returns:
    #   $v0 = gScore (or -1 if not set)
get_g_score:
    # Calculate the index of the node in the nodes array
    lw      $t0,                        map_width                                   # Load map width
    mul     $t1,                        $a1,            $t0                         # t1 = y * width
    add     $t1,                        $t1,            $a0                         # t1 = y * width + x

    # Calculate the address of the node
    lw      $t2,                        node_size                                   # Load size of each node
    mul     $t3,                        $t1,            $t2                         # t3 = (y * width + x) * node_size
    la      $t4,                        nodes                                       # Base address of nodes array
    add     $t4,                        $t4,            $t3                         # t4 = &nodes[y * width + x]

    # Retrieve the gScore field of the node
    lw      $v0,                        gScore($t4)                                 # Load the gScore value from the gScore offset

    jr      $ra
                    .include    "..\bitmap\bitmap_helper.asm"
