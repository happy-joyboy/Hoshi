
.text

manhattan_heuristic:            # Manhattan distance (|x1 - x2| + |y1 - y2|)
    # Inputs:
    #   $a0: address of current node
    #   $a1: address of goal node
    # Output:
    #   $v0: Manhattan distance


    lw      $t0,    0($a0)      # Load current.x
    lw      $t1,    0($a1)      # Load goal.x
    lw      $t2,    4($a0)      # Load current.y
    lw      $t3,    4($a1)      # Load goal.y

    sub     $t4,    $t0,    $t1 # t4 = current.x - goal.x
    bltz    $t4,    neg_x       # If t4 < 0, branch to neg_x
    sub     $t5,    $t2,    $t3 # t5 = current.y - goal.y
    bltz    $t5,    neg_y       # If t5 < 0, branch to neg_y

    add     $v0,    $t4,    $t5 # v0 = |current.x - goal.x| + |current.y - goal.y|
    jr      $ra                 # Return to caller

neg_x:
    sub     $t4,    $zero,  $t4 # t4 =  zero - t4
    jr      $ra                 # Return to caller
neg_y:
    sub     $t5,    $zero,  $t5 # t5 =  zero - t5
    jr      $ra                 # Return to caller


euclidean_heuristic:
    # Load x and y of current node
    lw   $t0, 0($a0)      # t0 = current.x
    lw   $t1, 4($a0)      # t1 = current.y

    # Load x and y of goal node
    lw   $t2, 0($a1)      # t2 = goal.x
    lw   $t3, 4($a1)      # t3 = goal.y

    # Calculate (x1 - x2)
    sub  $t4, $t0, $t2

    # Calculate (y1 - y2)
    sub  $t5, $t1, $t3

    # Convert (x1-x2) to float
    mtc1 $t4, $f1
    cvt.s.w $f1, $f1

    # Convert (y1-y2) to float
    mtc1 $t5, $f2
    cvt.s.w $f2, $f2

    # Square both
    mul.s $f3, $f1, $f1      # (x1-x2)^2
    mul.s $f4, $f2, $f2      # (y1-y2)^2

    # Add
    add.s $f5, $f3, $f4      # (x1-x2)^2 + (y1-y2)^2

    # Take square root
    sqrt.s $f0, $f5

    jr $ra
