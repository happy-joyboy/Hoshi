.data
# Messages
msg_insert: .asciiz "Inserting node: "
# msg_extract: .asciiz "Extracted node: "
msg_heap: .asciiz "Heap state: "
newline: .asciiz "\n"

# Space for extracted node
# extracted_node: .space 20 # 4B x + 4B y + 4B g + 4B h + 4B parent_idx

.text
.globl main

main:
    # Test 1: Insert nodes into the priority queue
    la $a0, msg_insert
    li $v0, 4      # Print string syscall
    syscall

    # Insert first node
    li $a0, 1      # x = 1
    li $a1, 2      # y = 2
    li $a2, 10     # g = 10
    li $a3, 15     # h = 15
    li $t0, -1     # parent_idx = -1
    sw $t0, 0($sp) # Push parent_idx onto the stack
    jal push       # Call push

    # Insert second node
    li $a0, 3      # x = 3
    li $a1, 4      # y = 4
    li $a2, 5      # g = 5
    li $a3, 10     # h = 10
    li $t0, 0      # parent_idx = 0
    sw $t0, 0($sp) # Push parent_idx onto the stack
    jal push       # Call push

    # Insert third node
    li $a0, 0      # x = 0
    li $a1, 1      # y = 1
    li $a2, 20     # g = 20
    li $a3, 5      # h = 5
    li $t0, 1      # parent_idx = 1
    sw $t0, 0($sp) # Push parent_idx onto the stack
    jal push       # Call push

    # Print heap state after inserts
    la $a0, msg_heap
    li $v0, 4      # Print string syscall
    syscall

    jal print_heap # Call print_heap to display the heap

    # Test 2: Extract nodes from the priority queue
    la $a0, extracted_node # Address to store extracted node
    jal pop                # Call pop

    # Print extracted node
    la $a0, msg_extract
    li $v0, 4      # Print string syscall
    syscall

    jal print_extracted_node # Print the extracted node

    # Print updated heap state
    la $a0, msg_heap
    li $v0, 4      # Print string syscall
    syscall

    jal print_heap # Call print_heap to display the updated heap

    # Exit program
    li $v0, 10     # Exit syscall
    syscall

# === Helper Functions ===

# Print the extracted node
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

    # Print g
    lw $a0, 8($t0)     # Load g
    li $v0, 1          # Print integer syscall
    syscall

    # Print a comma and space
    la $a0, message_coma
    li $v0, 4          # Print string syscall
    syscall

    # Print h
    lw $a0, 12($t0)    # Load h
    li $v0, 1          # Print integer syscall
    syscall

    # Print a comma and space
    la $a0, message_coma
    li $v0, 4          # Print string syscall
    syscall

    # Print parent index
    lw $a0, 16($t0)    # Load parent_idx
    li $v0, 1          # Print integer syscall
    syscall

    # Print a newline
    la $a0, newline
    li $v0, 4          # Print string syscall
    syscall

    jr $ra

    .include "new_pq.asm" # Include the priority queue implementation
