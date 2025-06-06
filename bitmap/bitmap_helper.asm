
.text
    .globl  bitmapMain, clearScreen, drawPixel, drawGridNode, drawGrid
bitmapMain:
    jal     clearScreen
    la      $a0,                map_data
    li      $a1,                0
    li      $a2,                1
    jal     drawGrid
exitProgram:
    li      $v0,                10
    syscall


clearScreen:
    li      $t0,                bitmapBaseAddress
    li      $t1,                displayWidth
    mul     $t1,                $t1,                displayHeight
    sll     $t1,                $t1,                2
    add     $t1,                $t1,                bitmapBaseAddress
    li      $t2,                0x808080                                # Black color

clearLoop:
    sw      $t2,                0($t0)
    addi    $t0,                $t0,                4
    blt     $t0,                $t1,                clearLoop
    jr      $ra
    # $a0 = base address , $a1 = free space     , $a2 = wall color
drawGrid:
    li      $s0,                0
    move    $s2,                $a0
outer_loop:
    bge     $s0,                gridHeight,         drawGridEnd
    li      $s1,                0
inner_loop:
    bge     $s1,                gridWidth,          outer_loop_next
    mul     $t0,                $s0,                gridWidth
    add     $t0,                $t0,                $s1
    sll     $t0,                $t0,                2
    add     $t0,                $t0,                $s2
    lw      $a2,                0($t0)
    move    $a0,                $s1
    move    $a1,                $s0
    addi    $sp,                $sp,                -4
    sw      $ra,                0($sp)
    jal     drawGridNode


    #delay
    li $a0, 10        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
    syscall
    addi    $s1,                $s1,                1
    j       inner_loop
outer_loop_next:
    addi    $s0,                $s0,                1
    j       outer_loop
drawGridEnd:
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4
    jr      $ra


drawGridNode:
    # save return address
    addi    $sp,                $sp,                -4
    sw      $ra,                0($sp)

    # baseX = a0 * gridCellWidth
    li      $t5,                gridCellWidth
    mul     $t5,                $a0,                $t5
    move    $s7,                $t5

    # baseY = a1 * gridCellHeight
    li      $t6,                gridCellHeight
    mul     $t6,                $a1,                $t6

    addi    $t7,                $t5,                gridCellWidth
    addi    $t8,                $t6,                gridCellHeight


row_loop_bitmap:
    bge     $t6,                $t8,                finish
    move    $t5,                $s7
col_loop_bitmap:
    bge     $t5,                $t7,                next_row_bitmap

    move    $a0,                $t5
    move    $a1,                $t6
    jal     drawPixel
    addi    $t5,                $t5,                1

    j       col_loop_bitmap

next_row_bitmap:
    addi    $t6,                $t6,                1
    j       row_loop_bitmap


finish:
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4
    jr      $ra

calculateAddress:
    li      $v0,                bitmapBaseAddress

    mul     $t0,                $a1,                displayWidth
    add     $t0,                $t0,                $a0
    sll     $t0,                $t0,                2
    add     $v0,                $v0,                $t0
    jr      $ra

getColor:
    la      $t0,                colorTable
    sll     $t1,                $a2,                2
    add     $t0,                $t0,                $t1
    lw      $v1,                0($t0)
    jr      $ra

drawPixel:
    bltz    $a0,                drawPixelexit
    bltz    $a1,                drawPixelexit
    bge     $a0,                displayWidth,       drawPixelexit
    bge     $a1,                displayHeight,      drawPixelexit
    addi    $sp,                $sp,                -4
    sw      $ra,                0($sp)
    jal     calculateAddress
    jal     getColor
    sw      $v1,                0($v0)
    lw      $ra,                0($sp)
    addi    $sp,                $sp,                4
    jr      $ra
drawPixelexit:
    jr      $ra                                                         # jump to $ra
