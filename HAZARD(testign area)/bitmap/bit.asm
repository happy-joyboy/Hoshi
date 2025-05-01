    .data
        .eqv    displayWidth, 32                                            # Width of the display in units 512 / 32 = 16
        .eqv    displayHeight, 32                                           # Height of the display in units 512 / 32 = 16
        .eqv    gridCellWidth, 2                                            # Size of the display in bytes
        .eqv    gridCellHeight, 2                                           # Size of the display in bytes
        .eqv    gridWidth, 8
        .eqv    gridHeight, 8
        .eqv    bitmapBaseAddress, 0x10040000

        # Line endpoints
        startX: .word 2                          # Starting X coordinate
        startY: .word 2                          # Starting Y coordinate
        endX:   .word 10                         # Ending X coordinate
        endY:   .word 10                         # Ending Y coordinate

    colorTable:
        .word   0x000000    # Black (background)
        .word   0xFF0000    # Red
        .word   0x00FF00    # Green
        .word   0x0000FF    # Blue
        .word   0xFFFF00    # Yellow
        .word   0xFF00FF    # Magenta
        .word   0x00FFFF    # Cyan
        .word   0xFFFFFF    # White
        .word   0x808080    # Gray
        .word   0xFFA500    # Orange
        .word   0x800080    # Purple
        .word   0x008000    # Dark Green
        .word   0x000080    # Navy
        .word   0xA52A2A    # Brown
        .word   0xFFFFE0    # Light Yellow
        .word   0xD3D3D3    # Light Gray
        .word   0xFFB6C1    # Light Pink
        .word   0xADD8E6    # Light Blue
        .word   0x90EE90    # Light Green
        .word   0xFF69B4    # Hot Pink
        .word   0x20B2AA    # Light Sea Green
        .word   0xFF4500    # Orange Red
        .word   0xFFD700    # Gold
        .word   0x8B0000    # Dark Red
        .word   0x2E8B57    # Sea Green
        .word   0x4682B4    # Steel Blue
        .word   0xB8860B    # Dark Golden Rod
        .word   0x5F9EA0    # Cadet Blue

.text
    main:
        # Initialize variables
        li $s0, 0          # Frame counter
        jal clearScreen
    animation_loop:
    # 1. Clear the screen for each frame
    jal clearScreen
    
    # 2. Calculate new positions for objects
    lw $a0, startX     # Load the base coordinates
    lw $a1, startY
    lw $a2, endX
    lw $a3, endY
    
    # Add animation by adjusting coordinates based on frame counter
    add $a0, $a0, $s0  # Shift startX
    add $a2, $a2, $s0  # Shift endX
    
    # Draw a diagonal line between the points
    jal drawline
    
    # Draw another line (horizontal)
    li $a0, 2          # Fixed startX
    li $a1, 15         # Fixed startY
    li $a2, 20         # Fixed endX
    li $a3, 15         # Same Y for horizontal line
    jal drawline
    
    # Draw another line (vertical)
    li $a0, 25         # Fixed startX
    li $a1, 5          # Fixed startY
    li $a2, 25         # Same X for vertical line
    li $a3, 25         # Fixed endY
    jal drawline
    
    # 3. Add delay
    li $a0, 100        # 100 milliseconds delay
    li $v0, 32         # syscall for sleep
    syscall
    
    # 4. Increment frame counter
    addi $s0, $s0, 1
    
    # 5. Reset frame counter after 20 frames
    beq $s0, 20, reset_frame
    
    # 6. Repeat the loop
    j animation_loop

    clearScreen:
        li      $t0,                bitmapBaseAddress
        li      $t1,                displayWidth
        mul     $t1,                $t1,                displayHeight
        sll     $t1,                $t1,                2
        add     $t1,                $t1,                bitmapBaseAddress
        li      $t2,                0x000000                                # Black color
    clearLoop:
        sw      $t2,                0($t0)
        addi    $t0,                $t0,                4
        blt     $t0,                $t1,                clearLoop
        jr      $ra

getColor:
    la      $t0,                colorTable
    sll     $t1,                $a2,                2
    add     $t0,                $t0,                $t1
    lw      $v1,                0($t0)
    jr      $ra

    drawPixel:

        # Check bounds
        bltz $a0, drawPixelExit
        bltz $a1, drawPixelExit
        bge $a0, displayWidth, drawPixelExit
        bge $a1, displayHeight, drawPixelExit
        
        # Calculate address
        li $v0, bitmapBaseAddress
        mul $t0, $a1, displayWidth    # y * width
        add $t0, $t0, $a0             # + x
        sll $t0, $t0, 2               # * 4 bytes per pixel
        add $v0, $v0, $t0             # Add to base address
        
        # Get color
        la $t0, colorTable
        sll $t1, $a2, 2               # Color index * 4
        add $t0, $t0, $t1
        lw $t0, 0($t0)                # Load RGB color
        
        # Store color
        sw $t0, 0($v0)                # Write to memory
        
    drawPixelExit:
        jr $ra

drawline:
    # arguments: $a0=startX, $a1=startY, $a2=endX, $a3=endY
    move $s2, $ra            # Save return address
    
    # Store parameters in temp registers
    move $t0, $a0            # x0 = startX
    move $t1, $a1            # y0 = startY
    move $t2, $a2            # x1 = endX
    move $t3, $a3            # y1 = endY
    
    # Calculate dx, dy
    sub $t4, $t2, $t0        # dx = x1 - x0
    sub $t5, $t3, $t1        # dy = y1 - y0

    # Fast path for horizontal lines (dy = 0)
    bnez $t5, not_horizontal
    
    # Draw horizontal line (ensure x0 <= x1)
    ble $t0, $t2, h_line_start
    # Swap x0 and x1
    move $t6, $t0
    move $t0, $t2
    move $t2, $t6
    
h_line_start:
    move $t6, $t0            # current x = x0
h_line_loop:
    move $a0, $t6            # Set x coordinate
    move $a1, $t1            # Set y coordinate
    li $a2, 1                # Base color (red)
    add $a2, $a2, $s0        # Vary color based on frame counter
    jal drawPixel
    addi $t6, $t6, 1         # x++
    ble $t6, $t2, h_line_loop
    j line_end
    
not_horizontal:
    # Fast path for vertical lines (dx = 0)
    bnez $t4, not_vertical
    
    # Draw vertical line (ensure y0 <= y1)
    ble $t1, $t3, v_line_start
    # Swap y0 and y1
    move $t6, $t1
    move $t1, $t3
    move $t3, $t6
    
v_line_start:
    move $t6, $t1            # current y = y0
v_line_loop:
    move $a0, $t0            # Set x coordinate
    move $a1, $t6            # Set y coordinate
    li $a2, 1                # Base color (red)
    add $a2, $a2, $s0        # Vary color based on frame counter
    jal drawPixel
    addi $t6, $t6, 1         # y++
    ble $t6, $t3, v_line_loop
    j line_end
    
not_vertical:
    # General case: Bresenham's line algorithm
    
    # First, calculate absolute values of dx and dy
    move $a0, $t4
    jal absolute
    move $t4, $v0            # |dx|
    
    move $a0, $t5
    jal absolute
    move $t5, $v0            # |dy|
    
    # Determine whether x or y changes faster (steep line check)
    ble $t5, $t4, not_steep
    
    # For steep lines, swap x and y coordinates to ensure dx > dy
    # Swap (x0, y0)
    move $t6, $t0
    move $t0, $t1
    move $t1, $t6
    
    # Swap (x1, y1)
    move $t6, $t2
    move $t2, $t3
    move $t3, $t6
    
    # Recalculate dx, dy after swapping
    sub $t4, $t2, $t0        # dx = x1 - x0
    sub $t5, $t3, $t1        # dy = y1 - y0
    
    # Recalculate absolute values
    move $a0, $t4
    jal absolute
    move $t4, $v0            # |dx|
    
    move $a0, $t5
    jal absolute
    move $t5, $v0            # |dy|
    
    # Set the "swapped" flag
    li $t8, 1                # swapped = true
    j setup_bresenham
    
not_steep:
    li $t8, 0                # swapped = false
    
setup_bresenham:
    # Ensure we're drawing from left to right
    ble $t0, $t2, correct_direction
    
    # Swap start and end points
    # Swap x0 and x1
    move $t6, $t0
    move $t0, $t2
    move $t2, $t6
    
    # Swap y0 and y1
    move $t6, $t1
    move $t1, $t3
    move $t3, $t6
    
correct_direction:
    # Recalculate dx, dy after possible swaps
    sub $t4, $t2, $t0        # dx = x1 - x0
    sub $t5, $t3, $t1        # dy = y1 - y0
    
    # Decide if y increases or decreases
    slt $t6, $zero, $t5      # t6 = (0 < dy) ? 1 : 0
    beq $t6, $zero, y_decreases
    li $t7, 1                # y_step = 1
    j step_decided
    
y_decreases:
    li $t7, -1               # y_step = -1
    neg $t5, $t5             # Make dy positive
    
step_decided:
    # Initialize Bresenham algorithm variables
    sll $t6, $t5, 1          # error = 2 * dy
    sub $t6, $t6, $t4        # error = 2 * dy - dx
    move $t9, $t1            # y = y0
    
    # Main Bresenham loop
    move $s7, $t0            # current x = x0
bresenham_loop:
    # Plot the point (x, y)
    beqz $t8, plot_xy        # If not swapped, plot (x, y)
    # If swapped, plot (y, x) instead
    move $a0, $t9            # x = y
    move $a1, $s7            # y = x
    j do_plot
    
plot_xy:
    move $a0, $s7            # x
    move $a1, $t9            # y
    
do_plot:
    li $a2, 1                # Base color (red)
    add $a2, $a2, $s0        # Vary color based on frame counter
    jal drawPixel
    
    # Check if we've reached the end point
    beq $s7, $t2, line_end
    
    # Update error and possibly y
    bgez $t6, error_positive
    
    # error < 0
    sll $s6, $t5, 1          # 2 * dy
    add $t6, $t6, $s6        # error += 2 * dy
    j error_updated
    
error_positive:
    # error >= 0
    add $t9, $t9, $t7        # y += y_step
    sll $s6, $t5, 1          # 2 * dy
    sub $s6, $s6, $t4        # 2 * dy - dx
    sll $s5, $t4, 1          # 2 * dx
    sub $t6, $t6, $s5        # error -= 2 * dx
    add $t6, $t6, $s6        # error += (2 * dy - dx)
    
error_updated:
    addi $s7, $s7, 1         # x++
    j bresenham_loop
    
line_end:
    # Restore return address and return
    move $ra, $s2
    jr $ra

    # Get absolute value
    absolute:
        # a0 = input value
        # v0 = |input value|
        bgez $a0, abs_positive
        neg $v0, $a0
        jr $ra
    abs_positive:
        move $v0, $a0
        jr $ra

    reset_frame:
        li $s0, 0          # Reset frame counter
        jal clearScreen
        j animation_loop    # Jump back to the animation loop  