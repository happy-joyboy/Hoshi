.text
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