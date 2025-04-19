.data
# Strings for output
str_row:    .asciiz "Row "
str_col:    .asciiz " Col "
str_space:  .asciiz " "
str_newline:.asciiz "\n"
str_element:.asciiz "Element at ["
str_comma:  .asciiz ","
str_close:  .asciiz "]: "

# 3x3 nested array
map_width:    .word 3
map_height:   .word 3

# Map data (0 = walkable, 1 = obstacle)
map_data:     .word 0, 1, 0,   # Row 0
                    0, 1, 0,   # Row 1
                    0, 0, 0    # Row 2

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 2
goal_y:       .word 2



.text
.globl main
main:

    jal print_array

    li $v0, 10              # Exit program
    syscall
# Function to print the entire array
print_array:
    la $t0, map_data              # Base address
    lw $t1, map_height               # Row count
    lw $t2, map_width               # Column count
    li $t3, 0                  # Row counter
    
    print_row:
        beq   $t3, $t1, print_done  # If row counter equals row count, exit loop

        li $t4, 0                  # Column counter
    print_col:    
        beq $t4, $t2, next_row  # Critical fix: Check column counter
        
        # Calculate element address: base + (row * map_width + col) * 4
        mul $t5, $t3, $t2          # t5 = row * map_width
        add $t5, $t5, $t4          # t5 = row * map_width + col
        sll $t5, $t5, 2            # t5 = (row * map_width + col) * 4
        add $t5, $t5, $t0          # t5 = base + (row * map_width + col) * 4

        lw $a0, 0($t5)             # Load the element into a0
        li $v0, 1                  # Print integer syscall
        syscall                    # Print the element

        li $v0, 4
        la $a0, str_space
        syscall

        addi $t4, $t4, 1            # Increment column counter
        j print_col

    next_row:
        li $v0, 4
        la $a0, str_newline
        syscall
        addi $t3, $t3, 1
        j print_row
    
print_done:
    jr $ra