.data
heap: .space 1200 # 100-node heap 
extracted_node: .space 12
heapSize: .word 0 # Current Number of nodes in the heap
heap_capacity: .word 100 # Maximum number of nodes in the heap
# Messages
msg_heap: .asciiz "our Lovely Heap : "
msg_push_start: .asciiz "Starting push operation...\n"
msg_push_end: .asciiz "Push operation completed.\n"
msg_heap_empty: .asciiz "Heap is empty.\n"
msg_heap_full: .asciiz "Heap is full. Cannot insert.\n"
msg_extract: .asciiz "Extracted node: "
newline: .asciiz "\n"
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

    # Print a  and space
    la $a0, newline
    li $v0, 4            # Print string syscall
    syscall

    jal print_heap # Call print_heap to display the heap

    # Print extracted node
    la $a0, msg_extract
    li $v0, 4      # Print string syscall
    syscall

 # Test 2: Extract nodes from the priority queue
    la $a0, extracted_node # Address to store extracted node
    jal pop                # Call pop

    jal print_extracted_node # Print the extracted node

    # Print updated heap state
    la $a0, msg_heap
    li $v0, 4      # Print string syscall
    syscall

    jal print_heap # Call print_heap to display the updated heap

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

push_full:
    # Print "Heap is full" message
    la $a0, msg_heap_full
    li $v0, 4            # Print string syscall
    syscall
    jr $ra  

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

# === POP (EXTRACT MIN) ===
# returns the node with the minimum fScore (root of the heap) and removes it from the heap
# Argument: $a0 = address to store {x, y, fScore}
pop:
    #check if heap is empty
    lw  $t0, heapSize # load current size of heap
    beq $t0, $zero, pop_failed # if heap is empty you cant extract anything DUh

   # Save root node (min element)
    la   $t1, heap
    lw   $t2, 0($t1)        # x
    lw   $t3, 4($t1)        # y
    lw   $t4, 8($t1)        # fScore

    la  $t5, extracted_node # yessssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss finaly yessssssssssssssssssssssssssssssssssssssssssssssssssssssssss
    #add $t5, $t5, 12    


    # Store values into the provided struct
    sw   $t2, 0($t5)        # x
    sw   $t3, 4($t5)        # y
    sw   $t4, 8($t5)        # fScore

    # decrease heap size & check if heap is empty
    subi $t0, $t0, 1 
    sw   $t0, heapSize 
    beq  $t0, $zero, pop_end   # Heap is now empty if true

    # Load last node
    mul  $t5, $t0, 12
    add  $t5, $t1, $t5           # Last node address
    lw   $t6, 0($t5)             # last.x
    lw   $t7, 4($t5)             # last.y
    lw   $t8, 8($t5)             # last.fScore

    sw   $t6, 0($t1)             # Update root node with last node
    sw   $t7, 4($t1)
    sw   $t8, 8($t1)

    # Bubble down the new root node to restore our lovely heap property (the damn thing is broken so i need yo maintain order ...)
    li   $t3, 0  # set current_idx = 0

bubble_down:
    # Calculate left/right child indices
    sll  $t4, $t3, 1        # 2 * current_idx
    addi $t4, $t4, 1        # left_child = 2*current_idx + 1
    addi $t5, $t4, 1        # right_child = 2*current_idx + 2

    # Assume current is smallest
    move $t6, $t3           # smallest_idx = current_idx

    
   # Compare with left child
    bge  $t4, $t0, check_right
    la   $t7, heap
    mul  $t8, $t4, 12
    add  $t7, $t7, $t8
    lw   $t9, 8($t7)        # left_child.fScore
    la   $t8, heap
    mul  $t2, $t6, 12
    add  $t8, $t8, $t2
    lw   $t2, 8($t8)        # smallest.fScore
    bge  $t9, $t2, check_right
    move $t6, $t4           # smallest_idx = left_child

check_right:
    # Compare with right child
    bge  $t5, $t0, compare_smallest
    la   $t7, heap
    mul  $t8, $t5, 12
    add  $t7, $t7, $t8
    lw   $t9, 8($t7)        # right_child.fScore
    la   $t8, heap
    mul  $t2, $t6, 12
    add  $t8, $t8, $t2
    lw   $t2, 8($t8)        # smallest.fScore
    bge  $t9, $t2, compare_smallest
    move $t6, $t5           # smallest_idx = right_child

compare_smallest:
    # Swap if needed
    beq  $t6, $t3, pop_end
    # Swap current and smallest child
    la   $t7, heap
    mul  $t8, $t3, 12       # current address
    add  $t8, $t7, $t8
    mul  $t9, $t6, 12       # smallest address
    add  $t9, $t7, $t9

    # Swap x, y, fScore
    lw   $t0, 0($t8)
    lw   $t1, 4($t8)
    lw   $t2, 8($t8)
    lw   $t3, 0($t9)
    lw   $t4, 4($t9)
    lw   $t5, 8($t9)
    sw   $t3, 0($t8)
    sw   $t4, 4($t8)
    sw   $t5, 8($t8)
    sw   $t0, 0($t9)
    sw   $t1, 4($t9)
    sw   $t2, 8($t9)

    # Update current index
    move $t3, $t6
    j    bubble_down

pop_failed:
    # If heap is empty, return -1 for x, y, and fScore
    li   $t2, -1                # Error: x = -1
    sw   $t2, 0($a0)
    sw   $t2, 4($a0)            # y = -1
    sw   $t2, 8($a0)            # fScore = -1
pop_end:
    jr   $ra

print_extracted_node:
    la $t0, extracted_node # Load address of extracted node

    # Print x
    lw $a0, 0($t0)     # Load x
    li $v0, 1          # Print integer syscall
    syscall

    # Print a comma and space
    la $a0, message_coma
    li $v0, 4          # Print string syscall
    syscall

    # Print y
    lw $a0, 4($t0)     # Load y
    li $v0, 1          # Print integer syscall
    syscall

    # Print a comma and space
    la $a0, message_coma
    li $v0, 4          # Print string syscall
    syscall

    # Print fScore
    lw $a0, 8($t0)     # Load fScore
    li $v0, 1          # Print integer syscall
    syscall

    # Print a newline
    la $a0, newline
    li $v0, 4          # Print string syscall
    syscall

    jr $ra

# .......

# with all the hate :
    # JOYBOY :D