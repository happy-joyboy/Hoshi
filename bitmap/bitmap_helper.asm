.data
    .eqv    displayWidth, 16                                            # Width of the display in units 512 / 32 = 16
    .eqv    displayHeight, 16                                           # Height of the display in units 512 / 32 = 16
    .eqv    gridCellWidth, 2                                            # Size of the display in bytes
    .eqv    gridCellHeight, 2                                           # Size of the display in bytes
    .eqv    gridWidth, 8
    .eqv    gridHeight, 8
    .eqv    bitmapBaseAddress, 0x10040000
colorTable:
    .word   0xFAF9F6 # White (background)  0
    .word   0x000000 # Black (background)  1
    .word   0x00ff00 # Green               2
    .word   0xff0000 # Red                 3
    .word   0xffffff # White               4
    .word   0xFFFF00 # Yellow              5
    .word   0x0000FF # Blue               6
    .word   0xFF00FF # Magenta            7
    .word   0x00FFFF # Cyan              8
    .word   0x808080 # Gray               9
    .word   0xFFA500 # Orange            10
    .word   0x800080 # Purple           11
    .word   0xA52A2A # Brown            12
grid:
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   0, 1, 0, 1, 0, 1, 0, 0                                      # Row 1
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   0, 0, 1, 0, 0, 1, 0, 1                                      # Row 4
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3
    # .word   0, 0, 1, 0, 0, 1, 0, 1                                      # Row 4
.text
    .globl  clearScreen, drawPixel, drawGridNode, drawGrid
# main:
#     jal     clearScreen
#     la      $a0,                grid
#     li      $a1,                0
#     li      $a2,                1
#     jal     drawGrid
# exitProgram:
#     li      $v0,                10
#     syscall

clearScreen:
    li      $t0,                bitmapBaseAddress
    li      $t1,                displayWidth
    mul     $t1,                $t1,                displayHeight
    sll     $t1,                $t1,                2
    add     $t1,                $t1,                bitmapBaseAddress
    li      $t2,                0xff0ff0                                # Black color
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
