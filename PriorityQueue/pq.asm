.include    "data_pq.asm"
.text


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