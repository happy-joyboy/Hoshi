 .data
test_nodes: .word 3, 5, 10       # x, y, fScore
            .word 1, 2, 5
            .word 4, 4, 3
            .word 0, 0, 8
            .word 2, 3, 1

.text
.globl main
main:

    la   $s0, test_nodes
    li   $s1, 5                # 5 nodes in our test

insert_loop:
    lw $a0, 0($s0)
    lw $a1, 4($s0)
    lw $a2, 8($s0)
    jal push
    addi $s0, $s0, 12
    subi $s1, $s1, 1
    bne $s1, $zero, insert_loop

# the end or you can create a jump in main
    jal print_heap

    la $a0, popcorn
    li $v0, 4
    syscall

    jal pop

    la $a0, msg_extract
    li $v0, 4
    syscall
    
    jal print_EX_node


    # Exit
    li $v0, 10
    syscall


.include "pq.asm" 