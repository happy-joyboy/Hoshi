# this is a failure ........ 

DONT use this code
# this is a failure ........
# this is a failure ........
# this is a failure ........
# this is a failure ........ but i used it to learn alot actually

.include "pq.asm"  # Include your priority queue implementation

.data
test_nodes: .word 3, 5, 10       # x, y, fScore
            .word 1, 2, 5
            .word 4, 4, 3
            .word 0, 0, 8
            .word 2, 3, 1
result:     .space 60            # 5 nodes * 12 bytes each
newline:    .asciiz "\n"
space:      .asciiz " "

.text
.globl main
main:
    # Initialize heap
    la   $t9, heap
    sw   $t9, heap  # Store heap address if not already done in pq.asm

    # Insert test nodes
    la   $s0, test_nodes
    li   $s1, 5                 # 5 nodes to insert
insert_loop:
    lw   $a0, 0($s0)            # x
    lw   $a1, 4($s0)            # y
    lw   $a2, 8($s0)            # fScore
    jal  push
    addi $s0, $s0, 12           # Next node
    subi $s1, $s1, 1
    bnez $s1, insert_loop

    # Extract all nodes into 'result'
    la   $s2, result
    li   $s3, 5                 # 5 nodes to extract
extract_loop:
    move $a0, $s2               # Pass result address
    jal  pop
    addi $s2, $s2, 12           # Next result slot
    subi $s3, $s3, 1
    bnez $s3, extract_loop

    # Print results
    la   $s4, result
    li   $s5, 5
print_loop:
    # Print x
    lw   $a0, 0($s4)
    li   $v0, 1
    syscall
    la   $a0, space
    li   $v0, 4
    syscall
    
    # Print y
    lw   $a0, 4($s4)
    li   $v0, 1
    syscall
    la   $a0, space
    li   $v0, 4
    syscall
    
    # Print fScore
    lw   $a0, 8($s4)
    li   $v0, 1
    syscall
    la   $a0, newline
    li   $v0, 4
    syscall
    
    addi $s4, $s4, 12
    subi $s5, $s5, 1
    bnez $s5, print_loop

    # Exit
    li   $v0, 10
    syscall

# output:

#     Address | Data (x, y, fScore)
# -----------------------------
# 0x10010020 | 2, 3, 1    # Lowest fScore
# 0x1001002C | 4, 4, 3
# 0x10010038 | 1, 2, 5
# 0x10010044 | 0, 0, 8
# 0x10010050 | 3, 5, 10   # Highest fScore
