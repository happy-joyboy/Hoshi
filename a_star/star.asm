.data
# Movement directions (4-way: up, right, down, left)
    d4x:           .word 0, 1, 0, -1
    d4y:           .word -1, 0, 1, 0
    
    # Or 8-way movement (includes diagonals)
    d8x:         .word 0, 1, 1, 1, 0, -1, -1, -1
    d8y:         .word -1, -1, 0, 1, 1, 1, 0, -1
    
    # Message strings
    mesg_path_found:   .asciiz "Path found!\n"
    mesg_no_path:      .asciiz "No path exists.\n"

.text
.globl main

main:
    # Initialize stack pointer
    la $sp, 0x7FFFEFFC
    
    # Call A* algorithm
    jal a_star
    
    # Exit program
    li $v0, 10
    syscall

a_star:
    # Save return address and preserved registers
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    # Initialize
    jal initialize_nodes
    
    # Add start node to open set
    lw $a0, start_x      # x
    lw $a1, start_y      # y
    li $t0, 0            # g_score = 0
    
    # Set g_score for start node
    move $a2, $t0
    jal set_g_score
    
    # Calculate h_score for start node
    lw $a0, start_x
    lw $a1, start_y
    lw $a2, goal_x
    lw $a3, goal_y

    jal calculate_heuristic
    move $t1, $v0        # h_score
    
   # Calculate f_score = g_score + h_score
    add $t2, $t0, $t1    # f_score
    
    # Push start node to open set
    lw $a0, start_x      # x
    lw $a1, start_y      # y
    move $a2, $zero      # parent (none for start)
    move $a3, $t2        # f_score
    jal push             # Push node into the priority queue
    
    
    # Main loop
a_star_loop:
    # Check if open set is empty
    la $t0, heapSize
    lw $t1, 0($t0)
    beqz $t1, no_path_found
    
    # Pop node with lowest f_score
    jal pop
    
    # Check if popped node is goal
    la $t0, extracted_node
    lw $t1, 0($t0)       # x
    lw $t2, 4($t0)       # y

    # Check if popped node is goal
    lw $t3, goal_x
    lw $t4, goal_y
    bne $t1, $t3, not_goal
    bne $t2, $t4, not_goal
    
    # Found path to goal!
    j path_found
    
not_goal:
    # Add current node to closed set
    move $a0, $t1        # x
    move $a1, $t2        # y
    jal add_to_closed_set
    
    # Process neighbors
    move $s0, $t1        # Save current x
    move $s1, $t2        # Save current y
    
    # Get g_score of current node
    move $a0, $s0
    move $a1, $s1
    jal get_g_score
    move $s2, $v0        # Save g_score
    
    # Process each neighbor
    li $t0, 0            # Direction index
    
process_neighbors_loop:
    # Check if we've processed all directions
    li $t1, 4            # 4 directions
    beq $t0, $t1, a_star_loop
    
    # Calculate neighbor coordinates
    la $t2, d4x
    la $t3, d4y
    sll $t4, $t0, 2      # direction * 4
    add $t2, $t2, $t4
    add $t3, $t3, $t4
    lw $t2, 0($t2)       # dx
    lw $t3, 0($t3)       # dy
    
    add $t4, $s0, $t2    # neighbor_x = current_x + dx
    add $t5, $s1, $t3    # neighbor_y = current_y + dy
    
    # Save neighbor coordinates
    move $a0, $t4
    move $a1, $t5
    
    # Check if valid position
    jal is_valid_position
    beqz $v0, next_neighbor
    
    # Check if in closed set
    move $a0, $t4
    move $a1, $t5
    jal is_in_closed_set
    bnez $v0, next_neighbor
    
    # Calculate tentative g_score
    addi $t6, $s2, 1    # tentative_g = current_g + 10 (cost)
    
    # Get existing g_score for neighbor
    move $a0, $t4
    move $a1, $t5
    jal get_g_score
    move $t7, $v0        # neighbor's current g_score
    
    # If tentative_g >= existing g_score, skip
    bge $t6, $t7, next_neighbor
    
    # Update g_score
    move $a0, $t4
    move $a1, $t5
    move $a2, $t6
    jal set_g_score
    
    # Calculate h_score
    lw $a0, start_x
    lw $a1, start_y
    lw $a2, goal_x
    lw $a3, goal_y
    
    jal calculate_heuristic
    move $t7, $v0        # h_score
    
    # Calculate f_score = g_score + h_score
    add $t8, $t6, $t7    # f_score
    
    # Generate parent index
    sll $t9, $s1, 16     # parent_y << 16
    or $t9, $t9, $s0     # (parent_y << 16) | parent_x
    
    # Push to open set
    move $a0, $t4        # x
    move $a1, $t5        # y
    move $a2, $t9        # parent
    move $a3, $t8        # f_score
    jal push
    
next_neighbor:
    addi $t0, $t0, 1     # Next direction
    j process_neighbors_loop


a_star_exit:
    # Restore return address and preserved registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra


# a0 = x, a1 = y
# Returns v0 = 1 if valid, 0 if invalid
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
    mul $t3, $a1, $t0    # y * width
    add $t3, $t3, $a0    # y * width + x
    add $t2, $t2, $t3    # &map_data[y * width + x]
    lb $t4, 0($t2)
    bnez $t4, invalid_position  # If map_data[y][x] != 0, position is obstacle
    
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


no_path_found:
    # Print "No path exists" message
    la $a0, mesg_no_path
    li $v0, 4               # Print string syscall
    syscall
    j a_star_exit

path_found:
    # Print "Path found" message
    la $a0, mesg_path_found
    li $v0, 4               # Print string syscall
    syscall
    j a_star_exit

    # a0 = x, a1 = y
add_to_closed_set:
    # Calculate index in closed_set
    lw $t0, map_width
    mul $t1, $a1, $t0    # y * width
    add $t1, $t1, $a0    # y * width + x
    
    la $t2, closed_set
    add $t2, $t2, $t1    # &closed_set[y * width + x]
    li $t3, 1
    sb $t3, 0($t2)       # Mark as closed
    
    jr $ra


.include "node\Node_list.asm"
.include "func_calc\h_calc.asm"
