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

    # assume:
    #   heap:            space for N nodes (each 16 bytes)
    #   heapSize:        .word 0
    #   heap_capacity:   .word N
    #   extracted_node:  .space 16

.text
pop:
    # 1) Load heapSize, if zero → pop_failed
    la      $t0,                heapSize
    lw      $t1,                0($t0)
    beqz    $t1,                pop_failed

    # 2) Extract root into extracted_node
    la      $t2,                heap                                # base of heap array
    lw      $t3,                0($t2)                              # x
    lw      $t4,                4($t2)                              # y
    lw      $t5,                8($t2)                              # parent
    lw      $t6,                12($t2)                             # fScore
    la      $t7,                extracted_node
    sw      $t3,                0($t7)
    sw      $t4,                4($t7)
    sw      $t5,                8($t7)
    sw      $t6,                12($t7)

    # 3) Decrement heapSize; if it becomes 0 → done
    addi    $t1,                $t1,                -1
    sw      $t1,                0($t0)
    beqz    $t1,                pop_end

    # 4) Move last element into root
    la      $t2,                heap
    sll     $t3,                $t1,                4               # offset = index * 16
    add     $t4,                $t2,                $t3
    lw      $t7,                0($t4)
    lw      $t8,                4($t4)
    lw      $t9,                8($t4)
    lw      $t0,                12($t4)
    sw      $t7,                0($t2)
    sw      $t8,                4($t2)
    sw      $t9,                8($t2)
    sw      $t0,                12($t2)

    # 5) Bubble-down from index=0
    li      $s0,                0                                   # $s0 = current index

bubble_down:
    # compute child indices
    sll     $t1,                $s0,                1               # t1 = 2*idx
    addi    $t2,                $t1,                1               # leftIdx  = 2*idx + 1
    addi    $t3,                $t1,                2               # rightIdx = 2*idx + 2

    # reload heapSize
    la      $t4,                heapSize
    lw      $t5,                0($t4)

    # if leftIdx >= heapSize → no children → done
    bge     $t2,                $t5,                pop_end

    # if rightIdx >= heapSize → only left child exists
    bge     $t3,                $t5,                only_left_child

    # both children exist → pick the one with smaller fScore
    la      $t6,                heap
    sll     $t7,                $t2,                4
    add     $t8,                $t6,                $t7
    lw      $t9,                12($t8)                             # f_left
    sll     $t7,                $t3,                4
    add     $t8,                $t6,                $t7
    lw      $t0,                12($t8)                             # f_right
    blt     $t9,                $t0,                pick_left
    move    $s1,                $t3                                 # choose right
    j       do_swap

pick_left:
    move    $s1,                $t2                                 # choose left

only_left_child:
    move    $s1,                $t2                                 # only left child

do_swap:
    # compare node.fScore vs child.fScore
    la      $t6,                heap
    sll     $t7,                $s0,                4
    add     $t8,                $t6,                $t7
    lw      $t9,                12($t8)                             # f_node
    sll     $t7,                $s1,                4
    add     $t6,                $t6,                $t7
    lw      $t0,                12($t6)                             # f_child
    blt     $t9,                $t0,                pop_end         # if node ≤ child, heap property holds

    # swap the two full 16-byte nodes
    # node @ $t8, child @ $t6
    lw      $t1,                0($t8)
    lw      $t2,                0($t6)
    sw      $t2,                0($t8)
    sw      $t1,                0($t6)
    lw      $t1,                4($t8)
    lw      $t2,                4($t6)
    sw      $t2,                4($t8)
    sw      $t1,                4($t6)
    lw      $t1,                8($t8)
    lw      $t2,                8($t6)
    sw      $t2,                8($t8)
    sw      $t1,                8($t6)
    lw      $t1,                12($t8)
    lw      $t2,                12($t6)
    sw      $t2,                12($t8)
    sw      $t1,                12($t6)

    # continue bubbling down from new position
    move    $s0,                $s1
    j       bubble_down

pop_end:
    jr      $ra

pop_failed:
    # on empty-heap, write –1 into extracted_node
    la      $t1,                extracted_node
    li      $t2,                -1
    sw      $t2,                0($t1)
    sw      $t2,                4($t1)
    sw      $t2,                8($t1)
    sw      $t2,                12($t1)
    jr      $ra


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
    la      $t0,                nodes
    lw      $t1,                nodes_count
    li      $t2,                0

find_loop:
    bge     $t2,                $t1,                not_found

    lw      $t3,                node_size
    mul     $t4,                $t2,                $t3
    add     $t5,                $t0,                $t4

    lw      $t6,                x($t5)
    lw      $t7,                y($t5)

    beq     $t6,                $a0,                check_y
    j       next_node

check_y:
    beq     $t7,                $a1,                found_node

next_node:
    addi    $t2,                $t2,                1
    j       find_loop

found_node:
    move    $v0,                $t5
    jr      $ra

not_found:
    li      $v0,                0
    jr      $ra