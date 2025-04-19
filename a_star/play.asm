.data
    # Map dimensions
    map_width:    .word 64      # Example width
    map_height:   .word 64      # Example height
    
    # Map data (0 = walkable, 1 = obstacle)
    map_data:     .space 4096   # 64x64 grid = 4096 bytes
    
    # Start and goal positions
    start_x:      .word 0
    start_y:      .word 0
    goal_x:       .word 63
    goal_y:       .word 63
    
    # Open and closed sets
    open_set:     .space 16384  # Max number of nodes * 4 bytes per pointer
    open_set_size: .word 0
    closed_set:   .space 4096   # 64x64 grid = 4096 bytes
    
    # Node storage
    nodes:        .space 81920  # Space for up to 2,926 nodes (28 bytes each)
    next_node_id: .word 0
    
    # Movement directions (4-way: up, right, down, left)
    dx:           .word 0, 1, 0, -1
    dy:           .word -1, 0, 1, 0
    
    # Or 8-way movement (includes diagonals)
    # dx:         .word 0, 1, 1, 1, 0, -1, -1, -1
    # dy:         .word -1, -1, 0, 1, 1, 1, 0, -1
    
    # Message strings
    mesg_path_found:   .asciiz "Path found!\n"
    mesg_no_path:      .asciiz "No path exists.\n"

    a_star:
    # Initialize open and closed sets
    jal init_sets
    
    # Create and add start node to open set
    jal create_start_node
    
    a_star_loop:
        # Check if open set is empty
        lw $t0, open_set_size
        beqz $t0, no_path_found
        
        # Get node with lowest f_cost from open set
        jal get_lowest_f_node  # Returns node pointer in $v0
        move $s0, $v0          # Store current node in $s0
        
        # Check if current node is goal
        jal is_goal_node
        bnez $v0, path_found
        
        # Remove current node from open set
        move $a0, $s0
        jal remove_from_open_set
        
        # Add current node to closed set
        move $a0, $s0
        jal add_to_closed_set
        
        # Process neighbors
        move $a0, $s0
        jal process_neighbors
        
        j a_star_loop

no_path_found:
    # Print "No path exists" message
    li $v0, 4
    la $a0, mesg_no_path
    syscall
    j a_star_exit
    
path_found:
    # Print "Path found" message
    li $v0, 4
    la $a0, mesg_path_found
    syscall
    
    # Reconstruct and display path
    move $a0, $s0
    jal reconstruct_path
    
a_star_exit:
    jr $ra

# Calculate Manhattan distance heuristic
# Parameters: $a0 = node_x, $a1 = node_y
# Returns: $v0 = heuristic value
calculate_heuristic:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Load goal coordinates
    lw $t0, goal_x
    lw $t1, goal_y
    
    # Calculate |node_x - goal_x|
    sub $t2, $a0, $t0
    abs $t2, $t2
    
    # Calculate |node_y - goal_y|
    sub $t3, $a1, $t1
    abs $t3, $t3
    
    # h = |node_x - goal_x| + |node_y - goal_y|
    add $v0, $t2, $t3
    
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Process all neighbors of current node
# Parameters: $a0 = pointer to current node
process_neighbors:
    # Save return address and registers
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    move $s0, $a0  # $s0 = current node pointer
    
    # Load current node's position
    lw $s1, 0($s0)  # $s1 = current node's x
    lw $s2, 4($s0)  # $s2 = current node's y
    
    # Initialize direction index
    li $t0, 0  # Direction index
    
    process_neighbors_loop:
        # Check if we've processed all directions
        li $t1, 4  # Number of directions (4 for 4-way, 8 for 8-way)
        beq $t0, $t1, process_neighbors_exit
        
        # Calculate neighbor's coordinates
        la $t2, dx
        la $t3, dy
        sll $t4, $t0, 2  # $t4 = direction_index * 4
        add $t2, $t2, $t4
        add $t3, $t3, $t4
        lw $t2, 0($t2)  # $t2 = dx[direction_index]
        lw $t3, 0($t3)  # $t3 = dy[direction_index]
        
        add $a0, $s1, $t2  # neighbor_x = current_x + dx
        add $a1, $s2, $t3  # neighbor_y = current_y + dy
        
        # Check if neighbor is valid
        jal is_valid_position
        beqz $v0, process_next_neighbor
        
        # Check if neighbor is in closed set
        jal is_in_closed_set
        bnez $v0, process_next_neighbor
        
        # Calculate tentative g_cost
        lw $t4, 8($s0)  # $t4 = current node's g_cost
        li $t5, 10      # Cost of moving (10 for adjacent, 14 for diagonal)
        add $t5, $t4, $t5  # tentative_g = current_g + cost
        
        # Check if neighbor is in open set
        jal is_in_open_set
        move $t6, $v0  # $t6 = neighbor node pointer (0 if not in open set)
        
        beqz $t6, create_new_neighbor
        
        # Neighbor exists in open set, check if new path is better
        lw $t7, 8($t6)  # $t7 = neighbor's g_cost
        bge $t5, $t7, process_next_neighbor  # Skip if new path isn't better
        
        # Update neighbor's values
        sw $t5, 8($t6)  # Update g_cost
        
        # Update f_cost = g_cost + h_cost
        lw $t7, 12($t6)  # $t7 = h_cost
        add $t7, $t5, $t7
        sw $t7, 16($t6)  # Update f_cost
        
        # Update parent
        sw $s1, 20($t6)  # parent_x = current_x
        sw $s2, 24($t6)  # parent_y = current_y
        
        j process_next_neighbor
        
    create_new_neighbor:
        # Create new neighbor node
        move $t6, $a0  # Save neighbor_x
        move $t7, $a1  # Save neighbor_y
        
        # Allocate new node
        jal allocate_node
        move $t8, $v0  # $t8 = new node pointer
        
        # Set node values
        sw $t6, 0($t8)  # x_pos = neighbor_x
        sw $t7, 4($t8)  # y_pos = neighbor_y
        sw $t5, 8($t8)  # g_cost = tentative_g
        
        # Calculate h_cost
        move $a0, $t6
        move $a1, $t7
        jal calculate_heuristic
        sw $v0, 12($t8)  # h_cost = heuristic
        
        # Calculate f_cost = g_cost + h_cost
        add $t9, $t5, $v0
        sw $t9, 16($t8)  # f_cost = g_cost + h_cost
        
        # Set parent
        sw $s1, 20($t8)  # parent_x = current_x
        sw $s2, 24($t8)  # parent_y = current_y
        
        # Add to open set
        move $a0, $t8
        jal add_to_open_set
        
    process_next_neighbor:
        addi $t0, $t0, 1  # Increment direction index
        j process_neighbors_loop
        
    process_neighbors_exit:
        # Restore return address and registers
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        addi $sp, $sp, 16
        jr $ra

# Check if position is valid (within bounds and not an obstacle)
# Parameters: $a0 = x, $a1 = y
# Returns: $v0 = 1 if valid, 0 if invalid
is_valid_position:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if within bounds
    lw $t0, map_width
    lw $t1, map_height
    
    # Check x bounds
    bltz $a0, invalid_position
    bge $a0, $t0, invalid_position
    
    # Check y bounds
    bltz $a1, invalid_position
    bge $a1, $t1, invalid_position
    
    # Check if obstacle
    la $t2, map_data
    mul $t3, $a1, $t0  # $t3 = y * width
    add $t3, $t3, $a0  # $t3 = y * width + x
    add $t2, $t2, $t3  # $t2 = &map_data[y * width + x]
    lb $t2, 0($t2)
    bnez $t2, invalid_position  # If map_data[y][x] != 0, position is obstacle
    
    # Position is valid
    li $v0, 1
    j is_valid_exit
    
invalid_position:
    li $v0, 0
    
is_valid_exit:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Allocate new node
# Returns: $v0 = pointer to new node
allocate_node:
    # Calculate address of new node
    la $t0, nodes
    lw $t1, next_node_id
    li $t2, 28  # Size of node in bytes
    mul $t3, $t1, $t2  # $t3 = next_node_id * node_size
    add $v0, $t0, $t3  # $v0 = nodes + next_node_id * node_size
    
    # Increment next_node_id
    addi $t1, $t1, 1
    sw $t1, next_node_id
    
    jr $ra

# Reconstruct path from goal to start
# Parameters: $a0 = goal node pointer
reconstruct_path:
    # Implementation would trace parent pointers back to start
    # and either display or store the path
    # ...
    
    jr $ra