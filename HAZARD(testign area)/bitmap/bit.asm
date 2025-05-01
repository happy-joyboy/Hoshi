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
        
    animation_loop:
        # 1. Clear the screen
        # jal clearScreen
        
        # 2. Calculate new positions for objects
        # (Update positions based on frame counter or other logic)

        # la $t0, startX
        # lw $a0, 0($t0)                # Load startX
        # add $a0, $a0, $s0              # Update startX based on frame counter
        
        # rem $a0, $a0, displayWidth    # Keep within display width

        # la $t1, startY
        # lw $a1, 0($t1)                # Load startY
        # add $a1, $a1, $s0              # Update startY based on frame counter

        # rem $a1, $a1, displayHeight   # Keep within display height

        # # Set color to red (index 1)
        # li $a2, 1
        # add $a2, $a2, $s0              # Update color index based on frame counter
        
        lw $a0, startX
        lw $a1, startY
        lw $a2, endX
        lw $a3, endY

        add $a1, $a1, $s0              # Update startX based on frame counter
        add $a2, $a2, $s0              # Update endX based on frame counter
        add $a3, $a3, $s0              # Update endY based on frame counter
        # 3. Draw objects at their new positions
        jal drawline
        
        # 4. Add delay
        li $a0, 200         # 100 milliseconds delay
        li $v0, 32         # syscall for sleep
        syscall
        
        # 5. Increment frame counter
        addi $s0, $s0, 1
        
        beq $s0, 20, reset_frame # Reset frame counter after 20 frames
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
        # arguments: startX, startY, endX, endY
        # a0 = startX
        # a1 = startY
        # a2 = endX
        # a3 = endY
        move $s2, $ra            # startX
        # Calculate the differences
        move $t8, $a0            # startX
        move $t1, $a1            # startY
        move $t2, $a2            # endX
        move $t3, $a3            # endY
        sub $t4, $a2, $a0            # dx = endX - startX
        sub $t5, $a3, $a1            # dy = endY - startY

        # Calculate the absolute values of dx and dy
        flag:
        bltz $t4, negX
        bltz $t5, negY

        move $a0, $t1            # startY
        move $a1, $t3            # endY
        move $a2, $t5            # dy

        li $t6, 0
        bnez $t4, loopY

        loopy_end:
        move $a0, $t8            # startX
        move $a1, $t2            # endX
        move $a2, $t4            # dx
        li $t6, 0
        bnez $t1, loopX

        loopX:
           
            bge $t6, $t5, loopX_end

            add $a0, $t8, $t6 
            move $a1, $t1            # startY
            # Set color to red (index 1)
            li $a2, 1
            add $a2, $a2, $s0              # Update color index based on frame counter
            jal getColor

            jal drawPixel

            addi $t6, $t6, 1
        j loopX

        loopX_end:
        # If both dx and dy are zero, just draw the pixel at startX, startY

        move $a0, $t0            # startX
        move $a1, $t1            # startY

        # Set color to red (index 1)
        li $a2, 1
        add $a2, $a2, $s0              # Update color index based on frame counter
        jal getColor

        jal drawPixel

        move $ra, $s2            # startX
        jr $ra            # return to caller

        loopY:
           
            bge $t6, $t5, loopy_end

            move $a0, $t8            # startX
            add $a1, $t1, $t6        # startY + dy
            # Set color to red (index 1)
            li $a2, 1
            add $a2, $a2, $s0              # Update color index based on frame counter
            jal getColor

            jal drawPixel

            addi $t6, $t6, 1
        j loopY

        negX:
            sub     $t4, $zero, $t4   # t4 = zero - t4 (absolute value)
            j       flag
            
        negY:
            sub     $t5, $zero, $t5   # t5 = zero - t5 (absolute value)
            j       flag 

    reset_frame:
        li $s0, 0          # Reset frame counter
        j animation_loop    # Jump back to the animation loop  