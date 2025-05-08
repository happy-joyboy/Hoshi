
.data
manhattan_msg:    .asciiz "Manhattan Distance: "
chebyshev_msg:    .asciiz "Chebyshev Distance: "
octile_msg:       .asciiz "Octile Distance: "
# newline:          .asciiz "\n"
# Constant for (DIAGONAL_COST - DIRECT_COST) = (√2 - 1) ≈ 0.41421356
constant_oct:     .float 0.41421356

 .text
# .globl main

# #-----------------------------------------------------------
# # main: Test all heuristic functions
# #-----------------------------------------------------------
# main:
#     # Example coordinates: (2, 3) to (7, 8)
#     # -----------------------------------------
#     # Test Manhattan Distance:
#     li   $a0, 2        # x₁
#     li   $a1, 3        # y₁
#     li   $a2, 7        # x₂
#     li   $a3, 8        # y₂
#     jal  manhattanDistance   # call Manhattan function
#     move $t0, $v0     # store result in $t0

#     # Print Manhattan result:
#     li   $v0, 4
#     la   $a0, manhattan_msg
#     syscall

#     li   $v0, 1
#     move $a0, $t0
#     syscall

#     li   $v0, 4
#     la   $a0, newline
#     syscall

#     # -----------------------------------------
#     # Test Chebyshev Distance:
#     li   $a0, 2        # x₁
#     li   $a1, 3        # y₁
#     li   $a2, 7        # x₂
#     li   $a3, 8        # y₂
#     jal  chebyshevDistance   # call Chebyshev function
#     move $t1, $v0     # store result in $t1

#     # Print Chebyshev result:
#     li   $v0, 4
#     la   $a0, chebyshev_msg
#     syscall

#     li   $v0, 1
#     move $a0, $t1
#     syscall

#     li   $v0, 4
#     la   $a0, newline
#     syscall

#     # -----------------------------------------
#     # Test Octile Distance:
#     li   $a0, 2        # x₁
#     li   $a1, 3        # y₁
#     li   $a2, 7        # x₂
#     li   $a3, 8        # y₂
#     jal  octileDistance      # call Octile function; result returned in $f0

#     # Print Octile result (a float):
#     li   $v0, 2      # Service code for printing float
#     mov.s $f12, $f0  # Move result to $f12 for printing
#     syscall

#     li   $v0, 4
#     la   $a0, octile_msg
#     syscall

#     li   $v0, 4
#     la   $a0, newline
#     syscall

#     # Exit program
#     li   $v0, 10     # Exit syscall
#     syscall

#-----------------------------------------------------------
# Function: manhattanDistance
# Computes Manhattan distance = |x₂ - x₁| + |y₂ - y₁|
# Parameters:
#   $a0: x₁, $a1: y₁, $a2: x₂, $a3: y₂
# Returns:
#   $v0: Manhattan distance (integer)
#-----------------------------------------------------------
# manhattanDistance:
#     # Compute dx = x₂ - x₁
#     sub   $t0, $a2, $a0
#     bltz  $t0, m_abs_dx   # if dx < 0, jump to absolute conversion
#     j     m_continue_dx
# m_abs_dx:
#     sub   $t0, $zero, $t0  # t0 = -dx
# m_continue_dx:

#     # Compute dy = y₂ - y₁
#     sub   $t1, $a3, $a1
#     bltz  $t1, m_abs_dy   # if dy < 0, jump to absolute conversion
#     j     m_continue_dy
# m_abs_dy:
#     sub   $t1, $zero, $t1  # t1 = -dy
# m_continue_dy:

#     # Sum dx and dy to obtain Manhattan distance
#     add   $v0, $t0, $t1
#     jr    $ra             # Return from function

#-----------------------------------------------------------
# Function: chebyshevDistance
# Computes Chebyshev distance = max(|x₂ - x₁|, |y₂ - y₁|)
# Parameters:
#   $a0: x₁, $a1: y₁, $a2: x₂, $a3: y₂
# Returns:
#   $v0: Chebyshev distance (integer)
#-----------------------------------------------------------
chebyshevDistance:
    # Compute dx = x₂ - x₁
    sub   $t0, $a2, $a0
    bltz  $t0, c_abs_dx   # take absolute value if needed
    j     c_continue_dx
c_abs_dx:
    sub   $t0, $zero, $t0
c_continue_dx:

    # Compute dy = y₂ - y₁
    sub   $t1, $a3, $a1
    bltz  $t1, c_abs_dy
    j     c_continue_dy
c_abs_dy:
    sub   $t1, $zero, $t1
c_continue_dy:

    # Choose the maximum of dx and dy
    ble   $t0, $t1, chebyshev_use_dy
    move  $v0, $t0      # if dx > dy, result = dx
    jr    $ra
chebyshev_use_dy:
    move  $v0, $t1      # else result = dy
    jr    $ra

#-----------------------------------------------------------
# Function: octileDistance
# Computes Octile distance = max(dx, dy) + (√2 - 1)*min(dx, dy)
# where dx = |x₂ - x₁| and dy = |y₂ - y₁|
# Parameters:
#   $a0: x₁, $a1: y₁, $a2: x₂, $a3: y₂
# Returns:
#   $f0: Octile distance (float)
#-----------------------------------------------------------
octileDistance:
    # Compute dx = x₂ - x₁ and take absolute value
    sub   $t0, $a2, $a0
    bltz  $t0, o_abs_dx
    j     o_continue_dx
o_abs_dx:
    sub   $t0, $zero, $t0
o_continue_dx:

    # Compute dy = y₂ - y₁ and take absolute value
    sub   $t1, $a3, $a1
    bltz  $t1, o_abs_dy
    j     o_continue_dy
o_abs_dy:
    sub   $t1, $zero, $t1
o_continue_dy:

    # Determine maximum and minimum of dx and dy.
    # If dx <= dy, then max = dy, min = dx; else max = dx, min = dy.
    ble   $t0, $t1, o_dx_less
    # Case: dx > dy
    move  $t2, $t0   # max = dx
    move  $t3, $t1   # min = dy
    j     o_convert
o_dx_less:
    move  $t2, $t1   # max = dy
    move  $t3, $t0   # min = dx
o_convert:
    # Convert max (in $t2) and min (in $t3) to float
    mtc1  $t2, $f4
    cvt.s.w $f4, $f4    # f4 = float(max)
    mtc1  $t3, $f6
    cvt.s.w $f6, $f6    # f6 = float(min)

    # Load the constant (√2 - 1) from memory (approximately 0.41421356)
    l.s   $f8, constant_oct

    # Multiply: f10 = min * (√2 - 1)
    mul.s $f10, $f6, $f8

    # Add: result = max + (min * (√2 - 1))
    add.s $f0, $f4, $f10

    jr    $ra           # Return from function