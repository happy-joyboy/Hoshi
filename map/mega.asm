# the node_list data file

map_width:    .word 16
map_height:   .word 16

# 16x16 Map data (0 = walkable, 1 = obstacle)
map_data:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 0
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 1
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 2
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 3
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 4
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 5
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 6
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 7
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 8
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 9
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 10
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 11
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 12
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 13
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 14
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 15

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 15
goal_y:       .word 15

nodes:          .word  0:2304                                 # 64 nodes × 32 bytes
closed_set:     .word   0:256                                  # 1 node × 32 bytes
node_size:      .word   32                                  # Size of each node (32 bytes)
nodes_count:    .word   0                                   # Number of nodes created


#######################################################################
# bitmap_helper data

.data
    .eqv    displayWidth, 32                                            # Width of the display in units 1024 / 32 = 32
    .eqv    displayHeight, 32                                           # Height of the display in units 1024 / 32 = 32
    .eqv    gridCellWidth, 2                                            # Size of the display in bytes
    .eqv    gridCellHeight, 2                                           # Size of the display in bytes
    .eqv    gridWidth, 16
    .eqv    gridHeight, 16
    .eqv    bitmapBaseAddress, 0x10040000

grid:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 0
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 1
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 2
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 3
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 4
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 5
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 6
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 7
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 8
    .word 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 9
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 10
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 11
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 12
    .word 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 13
    .word 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 14
    .word 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 15