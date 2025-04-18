.data
# Priority Queue for A* Algorithm
# Node structure (20 bytes per node):
# - 4B x coordinate
# - 4B y coordinate
# - 4B g cost (cost from start)
# - 4B h cost (estimated cost to goal)
# - 4B parent index (to reconstruct path)
# Note: f cost (g + h) is calculated when needed

heap: .space 2000        # 100-node heap (20 bytes per node)
heapSize: .word 0        # Current number of nodes in the heap
heap_capacity: .word 100 # Maximum number of nodes in the heap
                                  # 4B x + 4B y + 4B parent + 4B fScore
extracted_node: .space 20 # 4B x + 4B y + 4B g + 4B h + 4B parent_idx

# Messages
msg_heap_full:  .asciiz "Heap is full. Cannot insert.\n"
msg_heap_empty: .asciiz "Heap is empty.\n"
msg_extract:    .asciiz "Extracted node: "
message_coma:   .asciiz ", "

.text
# === PUSH (INSERT) ===
# Arguments:
# $a0: x-coordinate (int)
# $a1: y-coordinate (int)
# $a2: g cost (int) - cost from start
# $a3: h cost (int) - estimated cost to goal
# Stack: 4($sp) - parent index (int)
push:
    # Preserve return address
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Load heap size and capacity
    la $t0, heapSize
    lw $t1, 0($t0)      # t1 = heapSize
    la $t2, heap_capacity
    lw $t3, 0($t2)      # t3 = heap_capacity

    # Check if the heap is full
    bge $t1, $t3, push_full

    # Calculate the address to insert the new node
    la $t4, heap
    mul $t5, $t1, 20     # t5 = heapSize * 20 (size of each node)
    add $t4, $t4, $t5    # t4 = heap + (heapSize * 20)

    # Insert the node (x, y, g, h, parent)
    sw $a0, 0($t4)       # Store x
    sw $a1, 4($t4)       # Store y
    sw $a2, 8($t4)       # Store g cost
    sw $a3, 12($t4)      # Store h cost
    lw $t6, 12($sp)      # Load parent index from stack
    sw $t6, 16($t4)      # Store parent index

    # Increment heap size
    addi $t1, $t1, 1
    sw $t1, 0($t0)

    # Initialize current index for bubble_up
    subi $s0, $t1, 1     # current_idx = heap_size - 1
    
    # Call bubble_up
    move $a0, $s0
    jal bubble_up

    # Restore return address and return
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# === BUBBLE UP ===
# Arguments:
# $a0: current index to bubble up
bubble_up:
    move $t3, $a0        # t3 = current_idx
    
bubble_up_loop:
    beq $t3, $zero, bubble_up_end # If current_idx == 0 (root node), stop

    # Calculate parent index (parent_idx = (current_idx - 1) / 2)
    subi $t4, $t3, 1     # t4 = current_idx - 1
    srl $t4, $t4, 1      # t4 = parent_idx (divide by 2)

    # Load parent node address
    la $t5, heap
    mul $t6, $t4, 20     # t6 = parent_idx * 20
    add $t5, $t5, $t6    # t5 = heap + (parent_idx * 20)
    
    # Load current node address
    la $t8, heap
    mul $t9, $t3, 20     # t9 = current_idx * 20
    add $t8, $t8, $t9    # t8 = heap + (current_idx * 20)
    
    # Calculate f scores (g + h) for comparison
    lw $t0, 8($t5)       # parent.g
    lw $t1, 12($t5)      # parent.h
    add $t7, $t0, $t1    # parent.f = parent.g + parent.h
    
    lw $t0, 8($t8)       # current.g
    lw $t1, 12($t8)      # current.h
    add $t2, $t0, $t1    # current.f = current.g + current.h

    # Compare f scores
    blt $t7, $t2, bubble_up_end # If parent.f < current.f, stop
    beq $t7, $t2, check_h_score # If f scores are equal, compare h scores
    
    j swap_nodes         # If parent.f > current.f, swap

check_h_score:
    # If f scores are equal, use h as tiebreaker (prefer lower h)
    lw $t0, 12($t5)      # parent.h
    lw $t1, 12($t8)      # current.h
    blt $t0, $t1, bubble_up_end # If parent.h < current.h, stop
    beq $t0, $t1, bubble_up_end # If h scores are also equal, stop

swap_nodes:
    # Swap current node and parent node (all 5 fields)
    # Load parent node values
    lw $t0, 0($t5)       # parent.x
    lw $t1, 4($t5)       # parent.y
    lw $t2, 8($t5)       # parent.g
    lw $t6, 12($t5)      # parent.h
    lw $t7, 16($t5)      # parent.parent_idx
    
    # Load current node values
    lw $s1, 0($t8)       # current.x
    lw $s2, 4($t8)       # current.y
    lw $s3, 8($t8)       # current.g
    lw $s4, 12($t8)      # current.h
    lw $s5, 16($t8)      # current.parent_idx
    
    # Store parent values in current node
    sw $t0, 0($t8)       # Store parent.x in current
    sw $t1, 4($t8)       # Store parent.y in current
    sw $t2, 8($t8)       # Store parent.g in current
    sw $t6, 12($t8)      # Store parent.h in current
    sw $t7, 16($t8)      # Store parent.parent_idx in current
    
    # Store current values in parent node
    sw $s1, 0($t5)       # Store current.x in parent
    sw $s2, 4($t5)       # Store current.y in parent
    sw $s3, 8($t5)       # Store current.g in parent
    sw $s4, 12($t5)      # Store current.h in parent
    sw $s5, 16($t5)      # Store current.parent_idx in parent

    # Update current index to parent index
    move $t3, $t4        # current_idx = parent_idx
    j bubble_up_loop     # Repeat the process

bubble_up_end:
    jr $ra               # Return

# === POP (EXTRACT MIN) ===
# Returns the node with the minimum f score (root of the heap) and removes it from the heap
# Arguments: $a0 = address to store extracted node (optional)
pop:
    # Preserve return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if heap is empty
    lw $t0, heapSize     # load current size of heap
    beq $t0, $zero, pop_failed # if heap is empty, can't extract
    
    # Save root node (min element)
    la $t1, heap
    lw $t2, 0($t1)       # x
    lw $t3, 4($t1)       # y
    lw $t4, 8($t1)       # g
    lw $t5, 12($t1)      # h
    lw $t6, 16($t1)      # parent_idx
    
    # Store values into extracted_node
    la $t7, extracted_node
    sw $t2, 0($t7)       # x
    sw $t3, 4($t7)       # y
    sw $t4, 8($t7)       # g
    sw $t5, 12($t7)      # h
    sw $t6, 16($t7)      # parent_idx
    
    # If $a0 is not null, copy to provided address
    beqz $a0, skip_copy
    sw $t2, 0($a0)       # x
    sw $t3, 4($a0)       # y
    sw $t4, 8($a0)       # g
    sw $t5, 12($a0)      # h
    sw $t6, 16($a0)      # parent_idx
    
skip_copy:
    # Decrease heap size & check if heap is empty
    subi $t0, $t0, 1 
    sw $t0, heapSize 
    beq $t0, $zero, pop_end # Heap is now empty if true
    
    # Load last node
    mul $t5, $t0, 20
    add $t5, $t1, $t5    # Last node address
    lw $t6, 0($t5)       # last.x
    lw $t7, 4($t5)       # last.y
    lw $t8, 8($t5)       # last.g
    lw $t9, 12($t5)      # last.h
    lw $s0, 16($t5)      # last.parent_idx
    
    # Update root node with last node
    sw $t6, 0($t1)       # root.x = last.x
    sw $t7, 4($t1)       # root.y = last.y
    sw $t8, 8($t1)       # root.g = last.g
    sw $t9, 12($t1)      # root.h = last.h
    sw $s0, 16($t1)      # root.parent_idx = last.parent_idx
    
    # Bubble down the new root node
    li $a0, 0            # current_idx = 0
    jal bubble_down
    
    j pop_end

pop_failed:
    # If heap is empty, return -1 for all fields
    beqz $a0, pop_end    # If no output address provided, just return
    
    li $t2, -1           # Error value
    sw $t2, 0($a0)       # x = -1
    sw $t2, 4($a0)       # y = -1
    sw $t2, 8($a0)       # g = -1
    sw $t2, 12($a0)      # h = -1
    sw $t2, 16($a0)      # parent_idx = -1
    
    # Print "Heap is empty" message
    la $a0, msg_heap_empty
    li $v0, 4
    syscall
    
pop_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# === BUBBLE DOWN ===
# Arguments:
# $a0: current index to bubble down
bubble_down:
    move $t3, $a0        # t3 = current_idx
    lw $t0, heapSize     # t0 = heap size
    
bubble_down_loop:
    # Calculate left/right child indices
    sll $t4, $t3, 1      # 2 * current_idx
    addi $t4, $t4, 1     # left_child = 2*current_idx + 1
    addi $t5, $t4, 1     # right_child = 2*current_idx + 2
    
    # Assume current is smallest
    move $t6, $t3        # smallest_idx = current_idx
    
    # Compare with left child
    bge $t4, $t0, check_right_child
    
    # Calculate f scores for comparison
    la $t7, heap
    mul $t8, $t3, 20     # current node offset
    add $t8, $t7, $t8    # current node address
    lw $s0, 8($t8)       # current.g
    lw $s1, 12($t8)      # current.h
    add $s2, $s0, $s1    # current.f = current.g + current.h
    
    mul $t9, $t4, 20     # left child offset
    add $t9, $t7, $t9    # left child address
    lw $s3, 8($t9)       # left.g
    lw $s4, 12($t9)      # left.h
    add $s5, $s3, $s4    # left.f = left.g + left.h
    
    # Compare f scores
    blt $s2, $s5, check_right_child # If current.f < left.f, check right
    bgt $s2, $s5, set_left_as_smallest # If current.f > left.f, left is smallest
    
    # If f scores are equal, use h as tiebreaker
    blt $s1, $s4, check_right_child # If current.h < left.h, check right
    
set_left_as_smallest:
    move $t6, $t4        # smallest_idx = left_child
    
check_right_child:
    # Compare with right child
    bge $t5, $t0, compare_smallest
    
    # Calculate f score for right child
    la $t7, heap
    mul $t9, $t5, 20     # right child offset
    add $t9, $t7, $t9    # right child address
    lw $s3, 8($t9)       # right.g
    lw $s4, 12($t9)      # right.h
    add $s5, $s3, $s4    # right.f = right.g + right.h
    
    # Get smallest node's f score
    mul $t8, $t6, 20     # smallest node offset
    add $t8, $t7, $t8    # smallest node address
    lw $s0, 8($t8)       # smallest.g
    lw $s1, 12($t8)      # smallest.h
    add $s2, $s0, $s1    # smallest.f = smallest.g + smallest.h
    
    # Compare f scores
    blt $s2, $s5, compare_smallest # If smallest.f < right.f, keep smallest
    bgt $s2, $s5, set_right_as_smallest # If smallest.f > right.f, right is smallest
    
    # If f scores are equal, use h as tiebreaker
    blt $s1, $s4, compare_smallest # If smallest.h < right.h, keep smallest
    
set_right_as_smallest:
    move $t6, $t5        # smallest_idx = right_child
    
compare_smallest:
    # If smallest is still current, we're done
    beq $t6, $t3, bubble_down_end
    
    # Swap current and smallest child
    la $t7, heap
    mul $t8, $t3, 20     # current offset
    add $t8, $t7, $t8    # current address
    mul $t9, $t6, 20     # smallest offset
    add $t9, $t7, $t9    # smallest address
    
    # Load current node values
    lw $s0, 0($t8)       # current.x
    lw $s1, 4($t8)       # current.y
    lw $s2, 8($t8)       # current.g
    lw $s3, 12($t8)      # current.h
    lw $s4, 16($t8)      # current.parent_idx
    
    # Load smallest node values
    lw $s5, 0($t9)       # smallest.x
    lw $s6, 4($t9)       # smallest.y
    lw $s7, 8($t9)       # smallest.g
    lw $t0, 12($t9)      # smallest.h
    lw $t1, 16($t9)      # smallest.parent_idx
    
    # Store smallest values in current node
    sw $s5, 0($t8)       # current.x = smallest.x
    sw $s6, 4($t8)       # current.y = smallest.y
    sw $s7, 8($t8)       # current.g = smallest.g
    sw $t0, 12($t8)      # current.h = smallest.h
    sw $t1, 16($t8)      # current.parent_idx = smallest.parent_idx
    
    # Store current values in smallest node
    sw $s0, 0($t9)       # smallest.x = current.x
    sw $s1, 4($t9)       # smallest.y = current.y
    sw $s2, 8($t9)       # smallest.g = current.g
    sw $s3, 12($t9)      # smallest.h = current.h
    sw $s4, 16($t9)      # smallest.parent_idx = current.parent_idx
    
    # Update current index to smallest index
    move $t3, $t6        # current_idx = smallest_idx
    lw $t0, heapSize     # Reload heap size
    j bubble_down_loop
    
bubble_down_end:
    jr $ra

# === PEEK ===
# Returns the top node without removing it
# Arguments: $a0 = address to store node data
peek:
    # Check if heap is empty
    lw $t0, heapSize
    beqz $t0, peek_empty
    
    # Copy root node to provided address
    la $t1, heap
    lw $t2, 0($t1)       # x
    lw $t3, 4($t1)       # y
    lw $t4, 8($t1)       # g
    lw $t5, 12($t1)      # h
    lw $t6, 16($t1)      # parent_idx
    
    sw $t2, 0($a0)       # x
    sw $t3, 4($a0)       # y
    sw $t4, 8($a0)       # g
    sw $t5, 12($a0)      # h
    sw $t6, 16($a0)      # parent_idx
    
    li $v0, 1            # Return success
    jr $ra
    
peek_empty:
    li $t2, -1           # Error value
    sw $t2, 0($a0)       # x = -1
    sw $t2, 4($a0)       # y = -1
    sw $t2, 8($a0)       # g = -1
    sw $t2, 12($a0)      # h = -1
    sw $t2, 16($a0)      # parent_idx = -1
    
    li $v0, 0            # Return failure
    jr $ra

# === IS_EMPTY ===
# Returns 1 if heap is empty, 0 otherwise
is_empty:
    lw $v0, heapSize
    beqz $v0, is_empty_true
    li $v0, 0            # Not empty
    jr $ra
    
is_empty_true:
    li $v0, 1            # Empty
    jr $ra

# === CLEAR ===
# Clears the heap
clear_heap:
    sw $zero, heapSize   # Set heap size to 0
    jr $ra

# === PRINT HEAP ===
# Prints all nodes in the heap
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
    mul $t4, $t3, 20     # t4 = index * 20
    add $t5, $t2, $t4    # t5 = heap + (index * 20)
    
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
    
    # Load and print g
    lw $a0, 8($t5)       # Load g
    li $v0, 1            # Print integer syscall
    syscall
    
    # Print a comma and space
    la $a0, message_coma
    li $v0, 4            # Print string syscall
    syscall
    
    # Load and print h
    lw $a0, 12($t5)      # Load h
    li $v0, 1            # Print integer syscall
    syscall
    
    # Print a comma and space
    la $a0, message_coma
    li $v0, 4            # Print string syscall
    syscall
    
    # Load and print parent index
    lw $a0, 16($t5)      # Load parent_idx
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
    
print_heap_end:
    jr $ra

push_full:
    # Print "Heap is full" message
    la $a0, msg_heap_full
    li $v0, 4            # Print string syscall
    syscall
    
    # Restore return address and return
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
