.data
# Priority Queue DS
# (each node: 12 bytes = 4B x + 4B y + 4B fScore)
heap: .space 1200 # 100-node heap 
heapSize: .word 0 # Current Number of nodes in the heap
heap_capacity: .word 100 # Maximum number of nodes in the heap
heapNodeSize: .word 12 # Size of each node in the heap (4B x + 4B y + 4B fScore)

# Messages
msg_insert: .asciiz "Inserting node: "
msg_extract: .asciiz "Extracted node: "
msg_heap: .asciiz "Heap state: "
msg_push_start: .asciiz "Starting push operation...\n"
msg_push_end: .asciiz "Push operation completed.\n"
msg_heap_empty: .asciiz "Heap is empty.\n"
msg_heap_full: .asciiz "Heap is full. Cannot insert.\n"
msg_register: .asciiz "Register values: "
msg_condition: .asciiz "Condition check: "
newline: .asciiz "\n"
space: .asciiz " "
message_coma: .asciiz ", "

.text
.globl main

main:
    # Test 1: Insert nodes into the priority queue
    la $a0, msg_push_start
    li $v0, 4      # Print string syscall
    syscall

    # Insert first node
    li $a0, 1      # x = 1
    li $a1, 2      # y = 2
    li $a2, 10     # fScore = 10
    jal push       # Call push

    # Insert second node
    li $a0, 3      # x = 3
    li $a1, 4      # y = 4
    li $a2, 5      # fScore = 5
    jal push       # Call push

    # Insert third node
    li $a0, 0      # x = 0
    li $a1, 1      # y = 1
    li $a2, 15     # fScore = 15
    jal push       # Call push

    la $a0, msg_push_end
    li $v0, 4      # Print string syscall
    syscall

    # Print heap state after inserts
    la $a0, msg_heap
    li $v0, 4      # Print string syscall
    syscall

    # Print a comma and space
    la $a0, newline
    li $v0, 4            # Print string syscall
    syscall

    jal print_heap # Call print_heap to display the heap

    # Exit program
    li $v0, 10     # Exit syscall
    syscall

# Push function: Inserts a node into the heap
# Arguments: $a0 = x, $a1 = y, $a2 = fScore
push:
    # Load heap size and capacity
    la $t0, heapSize
    lw $t1, 0($t0)      # t1 = heapSize
    la $t2, heap_capacity
    lw $t3, 0($t2)      # t3 = heap_capacity

    # Check if the heap is full
    bge $t1, $t3, push_full

    # Calculate the address to insert the new node
    la $t4, heap
    mul $t5, $t1, 12     # t5 = heapSize * 12 (size of each node)
    add $t4, $t4, $t5    # t4 = heap + (heapSize * 12)

    # Insert the node (x, y, fScore)
    sw $a0, 0($t4)       # Store x
    sw $a1, 4($t4)       # Store y
    sw $a2, 8($t4)       # Store fScore

    # Increment heap size
    addi $t1, $t1, 1
    sw $t1, 0($t0)

    # Initialize current index for bubble_up
    subi $t3, $t1, 1     # current_idx = heap_size - 1

    # Call bubble_up to restore heap property
    #jal bubble_up

# Bubble up function: Restores the heap property after insertion
# Uses $t3 as current_idx
bubble_up:
    beq $t3, $zero, bubble_up_end # If current_idx == 0 (root node), stop

    # Calculate parent index (parent_idx = (current_idx - 1) / 2)
    subi $t4, $t3, 1     # t4 = current_idx - 1
    srl $t4, $t4, 1      # t4 = parent_idx (divide by 2)

    # Load fScore of parent node
    la $t5, heap
    mul $t6, $t4, 12     # t6 = parent_idx * 12
    add $t5, $t5, $t6    # t5 = heap + (parent_idx * 12)
    lw $t7, 8($t5)       # t7 = parent.fScore

    # Load fScore of current node
    la $t8, heap
    mul $t9, $t3, 12     # t9 = current_idx * 12
    add $t8, $t8, $t9    # t8 = heap + (current_idx * 12)
    lw $t0, 8($t8)       # t0 = current.fScore

    # Compare fScores
    bge $t0, $t7, bubble_up_end # If current.fScore >= parent.fScore, stop

    # Swap current node and parent node
    lw $t0, 0($t5)       # Load parent.x
    lw $t1, 4($t5)       # Load parent.y
    lw $t2, 8($t5)       # Load parent.fScore

    lw $t6, 0($t8)       # Load current.x
    lw $t7, 4($t8)       # Load current.y
    lw $t9, 8($t8)       # Load current.fScore

    sw $t0, 0($t8)       # Store parent.x in current
    sw $t1, 4($t8)       # Store parent.y in current
    sw $t2, 8($t8)       # Store parent.fScore in current
    sw $t6, 0($t5)       # Store current.x in parent
    sw $t7, 4($t5)       # Store current.y in parent
    sw $t9, 8($t5)       # Store current.fScore in parent

    # Update current index to parent index
    move $t3, $t4        # current_idx = parent_idx
    j bubble_up          # Repeat the process

bubble_up_end:
    jr $ra               # Return

# Print the heap state
print_heap:
    la $t0, heapSize
    lw $t1, 0($t0)       # t1 = heapSize
    la $t2, heap         # t2 = heap base address

    beqz $t1, print_heap_empty # If heapSize == 0, print empty message

    # Loop through the heap and print each node
    li $t3, 0            # t3 = index
print_heap_loop:
    bge $t3, $t1, print_heap_end # Exit loop if index >= heapSize

    # Calculate the address of the current node
    mul $t4, $t3, 12     # t4 = index * 12
    add $t5, $t2, $t4    # t5 = heap + (index * 12)
   
    # Load and print x
    lw $a0, 0($t5)       # Load x
    li $v0, 1            # Print integer syscall
    syscall

    # Print a comma and space
    la $a0, message_coma
    li $v0, 4            # Print string syscall
    syscall

    # Load and print y
    lw $a0, 4($t5)       # Load y
    li $v0, 1            # Print integer syscall
    syscall

    # Print a comma and space
    la $a0, message_coma
    li $v0, 4            # Print string syscall
    syscall

    # Load and print fScore
    lw $a0, 8($t5)       # Load fScore
    li $v0, 1            # Print integer syscall
    syscall

    # Print a newline
    la $a0, newline
    li $v0, 4            # Print string syscall
    syscall

    # Increment index
    addi $t3, $t3, 1
    j print_heap_loop

print_heap_empty:
    la $a0, msg_heap_empty
    li $v0, 4            # Print string syscall
    syscall
    jr $ra

print_heap_end:
    jr $ra


push_full:
    # Print "Heap is full" message
    la $a0, msg_heap_full
    li $v0, 4            # Print string syscall
    syscall
    jr $ra  