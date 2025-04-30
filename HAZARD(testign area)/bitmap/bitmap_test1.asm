.data
    .eqv    displayWidth, 32                # Width of the display
    .eqv    displayHeight, 32               # Height of the display
    .eqv    bitmapBaseAddress, 0x10040000   # Base address for bitmap display
    .eqv    delay, 100                      # Delay between animation frames

colorTable:
    .word   0x000000    # Black (background)
    .word   0xFF0000    # Red
    .word   0x00FF00    # Green
    .word   0x0000FF    # Blue
    .word   0xFFFF00    # Yellow

.text
    .globl main

main:
    li $s0, 0      # Animation frame counter
    
animationLoop:
    # Clear screen
    jal clearScreen
    
    # Draw bouncing ball
    rem $t0, $s0, 20              # X position cycles through 0-19
    div $t1, $s0, 10              # Used to determine direction
    rem $t1, $t1, 2               # 0 or 1 (forward or backward)
    beqz $t1, moveForward
    
    # Move backward
    li $t2, 19
    sub $t0, $t2, $t0             # Reverse the position
    
moveForward:
    # Calculate y position (bouncing effect)
    mul $t3, $t0, $t0             # y = x^2 / 10 (parabola)
    div $t3, $t3, 10
    
    # Draw the ball (a 3x3 square)
    move $t4, $t0                 # Center x
    move $t5, $t3                 # Center y
    addi $t4, $t4, 5              # Offset from edge
    addi $t5, $t5, 5              # Offset from edge
    
    # Choose color based on position
    rem $a2, $s0, 4
    addi $a2, $a2, 1              # Colors 1-4
    
    # Draw the ball
    move $a0, $t4
    move $a1, $t5
    jal drawBall
    
    # Delay
    li $a0, delay
    li $v0, 32                    # Sleep syscall
    syscall
    
    # Increment frame counter
    addi $s0, $s0, 1
    j animationLoop

# Draw a 3x3 ball at position (a0, a1) with color a2
drawBall:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    move $s0, $a0                 # Center x
    move $s1, $a1                 # Center y
    move $s2, $a2                 # Color
    
    # Draw 3x3 square
    addi $t0, $s0, -1             # Left x
    addi $t1, $s1, -1             # Top y
    
    li $t2, 0                     # Row counter
ballRowLoop:
    li $t3, 0                     # Column counter
ballColLoop:
    add $a0, $t0, $t3             # x = left + col
    add $a1, $t1, $t2             # y = top + row
    move $a2, $s2                 # Color
    jal drawPixel
    
    addi $t3, $t3, 1              # Next column
    blt $t3, 3, ballColLoop
    
    addi $t2, $t2, 1              # Next row
    blt $t2, 3, ballRowLoop
    
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# Clear the screen with black color
clearScreen:
    li $t0, bitmapBaseAddress     # Start address
    li $t1, displayWidth
    mul $t1, $t1, displayHeight    # Calculate total pixels
    sll $t1, $t1, 2               # Multiply by 4 (bytes per pixel)
    add $t1, $t1, $t0             # End address
    
    li $t2, 0                     # Black color
clearLoop:
    sw $t2, 0($t0)                # Set pixel to black
    addi $t0, $t0, 4              # Next pixel
    blt $t0, $t1, clearLoop
    jr $ra

# Draw a single pixel at (a0, a1) with color index a2
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
