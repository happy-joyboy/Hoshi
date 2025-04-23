.text
manhattan_heuristic:
    # Inputs:
    #   $a0: current.x
    #   $a1: current.y
    #   $a2: goal.x
    #   $a3: goal.y
    # Output:
    #   $v0: Manhattan distance
    
    # Calculate |x1 - x2|
    sub     $t0, $a0, $a2     # t0 = current.x - goal.x
    bgez    $t0, skip_abs_x   # If t0 >= 0, skip making it positive
    neg     $t0, $t0          # t0 = |t0| (absolute value)
skip_abs_x:
    
    # Calculate |y1 - y2|
    sub     $t1, $a1, $a3     # t1 = current.y - goal.y
    bgez    $t1, skip_abs_y   # If t1 >= 0, skip making it positive
    neg     $t1, $t1          # t1 = |t1| (absolute value)
skip_abs_y:
    
    # Calculate Manhattan distance
    add     $v0, $t0, $t1     # v0 = |x1-x2| + |y1-y2|
    
    jr      $ra               # Return to caller

euclidean_heuristic:
    # Inputs:
    #   $a0: current.x
    #   $a1: current.y
    #   $a2: goal.x
    #   $a3: goal.y
    # Output:
    #   $v0: Approximate Euclidean distance
    
    # Calculate dx = |x1 - x2|
    sub     $t0, $a0, $a2     # t0 = current.x - goal.x
    bgez    $t0, skip_abs_x2  # If t0 >= 0, skip making it positive
    neg     $t0, $t0          # t0 = |t0| (absolute value)
skip_abs_x2:
    
    # Calculate dy = |y1 - y2|
    sub     $t1, $a1, $a3     # t1 = current.y - goal.y
    bgez    $t1, skip_abs_y2  # If t1 >= 0, skip making it positive
    neg     $t1, $t1          # t1 = |t1| (absolute value)
skip_abs_y2:
    
    # A simple approximation: max(dx, dy) + 0.5 * min(dx, dy)
    move    $v0, $t0          # Assume t0 is max
    move    $t2, $t1          # Assume t1 is min
    
    bge     $t0, $t1, max_is_correct
    # If we get here, t1 is actually max
    move    $v0, $t1          # v0 = max = t1
    move    $t2, $t0          # t2 = min = t0
max_is_correct:
    
    # Calculate v0 + t2/2 (approximately max + 0.5*min)
    srl     $t2, $t2, 1       # t2 = t2/2
    add     $v0, $v0, $t2     # v0 = max + (min/2)
    
    jr      $ra               # Return to caller