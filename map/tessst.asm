print_node_grid:
    la      $s0,            nodes                           # Base node address
    lw      $s1,            map_width                       # Grid width
    lw      $s2,            map_height                      # Grid height

    li      $s3,            0                               # Row counter (y)
print_row_loop:
    beq     $s3,            $s2,            print_end
    li      $s4,            0                               # Column counter (x)

print_col_loop:
    beq     $s4,            $s1,            next_print_row

    # Calculate current node address
    mul     $t0,            $s3,            $s1             # row * width
    add     $t0,            $t0,            $s4             # + column
    lw      $t1,            node_size
    mul     $t0,            $t0,            $t1             # × node_size
    add     $t0,            $s0,            $t0             # base + offset

    # Print node details
    li      $v0,            4
    la      $a0,            node_str
    syscall

    li      $v0,            1
    lw      $a0,            x($t0)                          # Print x (column index)
    syscall

    li      $v0,            4
    la      $a0,            comma
    syscall

    li      $v0,            1
    lw      $a0,            y($t0)                          # Print y (row index)
    syscall

    li      $v0,            4
    la      $a0,            wall_str
    syscall

    li      $v0,            1
    lw      $a0,            wall($t0)                       # Print wall status
    syscall

    li      $v0,            4
    la      $a0,            comma
    syscall

    li      $v0,            1
    lw      $a0,            gScore($t0)                     # Print gScore
    syscall

    li      $v0,            4
    la      $a0,            comma
    syscall

    li      $v0,            1
    lw      $a0,            hScore($t0)                     # Print hScore
    syscall

    li      $v0,            4
    la      $a0,            comma
    syscall

    li      $v0,            1
    lw      $a0,            fScore($t0)                     # Print fScore
    syscall

    li      $v0,            4
    la      $a0,            comma
    syscall

    li      $v0,            1
    lw      $a0,            parent_x($t0)                   # Print parent_x
    syscall

    li      $v0,            4
    la      $a0,            comma
    syscall

    li      $v0,            1
    lw      $a0,            parent_y($t0)                   # Print parent_y
    syscall

    li      $v0,            4
    la      $a0,            newline
    syscall

    addi    $s4,            $s4,            1               # Next column
    j       print_col_loop

next_print_row:
    li      $v0,            4
    la      $a0,            newline
    syscall
    addi    $s3,            $s3,            1               # Next row
    j       print_row_loop

print_end:
    jr      $ra