.data                                # Number of nodes created
    # Offsets for fields within the node structure
                .eqv    x, 0
                .eqv    y, 4
                .eqv    wall, 8                             # 4 bytes
                .eqv    gScore, 12
                .eqv    hScore, 16
                .eqv    fScore, 20
                .eqv    parent_x, 24
                .eqv    parent_y, 28

node_sizes:    .word 32
# Add to existing strings
hscore_str:    .asciiz " hScore: "
str_count:    .asciiz "\nTotal Nodes: "
str_manhattan: .asciiz "\nManhattan Heuristic: "
str_euclidean: .asciiz "\nEuclidean Heuristic: "

.text
.globl main

main:
    jal initialize_nodes
    # jal calculate_all_heuristics  # New function to apply heuristic
    jal print_node_grid_with_h     # Modified print function
    li $v0, 10
    syscall
    
# New function: Calculate heuristics for all nodes
calculate_all_heuristics:

    la $s0, nodes
    lw $s1, nodes_count
    li $s2, 0 # Node index
    lw $s3, node_size

    heuristic_loop:
    
        bge $s2, $s1, heuristic_done

        #load address of current node
        mul $t0, $s2, $s3
        add $t5, $s0, $t0
        
        # Load coordinates
        lw $a0, x($t1) # x coordinate
        lw $a1, y($t1) # y coordinate
        lw $a2, goal_x # goal x
        lw $a3, goal_y # goal y
        # Calculate Manhattan heuristic
        jal manhattan_heuristic
        sw $v0, hScore($t1) # Store heuristic in node

        addi $s2, $s2, 1 # Increment node index
        j heuristic_loop

heuristic_done:
    jr $ra

# Modified print function to show hScores
print_node_grid_with_h:
    la $s0, nodes
    lw $s1, nodes_count
    li $t2, 0

    li $v0, 4
    la $a0, str_count
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    move $s4, $ra

    print_loop_h:

        bge $t2, $s1, print_end_h


        lw $t3, node_size
        mul $t4, $t2, $t3
        add $t5, $s0, $t4

        # Debugging: Print loop counter and total nodes
        li $v0, 4
        la $a0, newline
        syscall

        li $v0, 1
        move $a0, $t2  # Print loop counter
        syscall

        li $v0, 4
        la $a0, comma
        syscall

        li $v0, 1
        move $a0, $1  # Print total nodes
        syscall

        li $v0, 4
        la $a0, newline
        syscall

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

        # Load coordinates
        lw $a0, x($t5) # x coordinate
        lw $a1, y($t5) # y coordinate
        lw $a2, goal_x # goal x
        lw $a3, goal_y # goal y
        # Calculate Manhattan heuristic
        jal manhattan_heuristic    # this motherfucker is cahnging the $ra
        move $t7, $v0 # Store heuristic in t1
        sw $t7, hScore($t5) # Store heuristic in node

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
        # move $ra, $s4
        j print_loop_h

print_end_h:
    move $ra, $s4
    jr $ra

.include "h_calc.asm"
.include "..\map\MII.asm"
.include "..\node\Node_list.asm"
