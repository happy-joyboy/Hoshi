############ the one who staed and witnessed the end ############
# bitmap data

.data
    .eqv    displayWidth, 16                                            # Width of the display in units 512 / 32 = 16
    .eqv    displayHeight, 16                                           # Height of the display in units 512 / 32 = 16
    .eqv    gridCellWidth, 2                                            # Size of the display in bytes
    .eqv    gridCellHeight, 2                                           # Size of the display in bytes
    .eqv    gridWidth, 8
    .eqv    gridHeight, 8
    .eqv    bitmapBaseAddress, 0x10040000

grid:
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   0, 1, 0, 1, 0, 1, 0, 0                                      # Row 1
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   0, 0, 1, 0, 0, 1, 0, 1                                      # Row 4
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3


###################################################################

    # 3x3 nested array
map_width:    .word 8
map_height:   .word 8

# Map data (0 = walkable, 1 = obstacle)
map_data:
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   0, 1, 0, 1, 0, 1, 0, 0                                      # Row 1
    .word   0, 0, 0, 0, 0, 0, 0, 0                                      # Row 0
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   0, 0, 1, 0, 0, 1, 0, 1                                      # Row 4
    .word   0, 1, 0, 0, 0, 1, 0, 0                                      # Row 2
    .word   1, 0, 1, 0, 0, 0, 1, 0                                      # Row 3
    # .word   0, 0, 1, 0, 0, 1, 0, 1                                      # Row 4

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 7
goal_y:       .word 7

nodes:          .word  0:576                                 # 64 nodes × 32 bytes
closed_set:     .word   0:64                                  # 1 node × 32 bytes
node_size:      .word   32                                  # Size of each node (32 bytes)
nodes_count:    .word   0                                   # Number of nodes created