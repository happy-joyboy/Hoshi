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

# Add to existing strings
hscore_str:    .asciiz " hScore: "
str_count:    .asciiz "Total Nodes: "

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

# Modified print function to show hScores
print_node_grid_with_h:
    la $t0, nodes
    lw $t1, nodes_count
    li $t2, 0

    li $v0, 4
    la $a0, str_count
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

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
.include "..\map\MII.asm"
.include "..\node\Node_list.asm"