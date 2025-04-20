.text

manhattan_heuristic:            # Manhattan distance (|x1 - x2| + |y1 - y2|)
    # Inputs:
    #   $a0: current.x
    #   $a1: current.y
    #   $a2: goal.x
    #   $a3: goal.y
    # Output:
    #   $v0: Manhattan distance

    # Save return address
    move $s0, $ra 

    sub     $t4, $a0, $a2     # t4 = current.x - goal.x
    bltz    $t4, neg_x        # If t4 < 0, branch to neg_x
x_done:
    sub     $t5, $a1, $a3     # t5 = current.y - goal.y
    bltz    $t5, neg_y        # If t5 < 0, branch to neg_y
y_done:
    add     $v0, $t4, $t5     # v0 = |current.x - goal.x| + |current.y - goal.y|
    
    jr      $ra               # Return to caller
    
neg_x:
    sub     $t4, $zero, $t4   # t4 = zero - t4 (absolute value)
    j       x_done            # Continue with y calculation
    
neg_y:
    sub     $t5, $zero, $t5   # t5 = zero - t5 (absolute value)
    j       y_done            # Continue with result calculation



euclidean_heuristic:
    # Inputs:
    #   $a0: current.x
    #   $a1: current.y
    #   $a2: goal.x
    #   $a3: goal.y
    # Output:
    #   $v0: Euclidean distance (rounded to nearest integer)

    # Calculate (x1 - x2)
    sub     $t4, $a0, $a2
    
    # Calculate (y1 - y2)
    sub     $t5, $a1, $a3
    
    # Convert (x1-x2) to float
    mtc1    $t4, $f1
    cvt.s.w $f1, $f1
    
    # Convert (y1-y2) to float
    mtc1    $t5, $f2
    cvt.s.w $f2, $f2
    
    # Square both
    mul.s   $f3, $f1, $f1     # (x1-x2)^2
    mul.s   $f4, $f2, $f2     # (y1-y2)^2
    
    # Add
    add.s   $f5, $f3, $f4     # (x1-x2)^2 + (y1-y2)^2
    
    # Take square root
    sqrt.s  $f0, $f5          # Result in $f0
    
    # Convert float result to integer (round to nearest)
    cvt.w.s $f0, $f0          # Convert to word format
    mfc1    $v0, $f0          # Move to integer register for return
    
    # Restore return address and return
    jr      $ra               # Return to caller
