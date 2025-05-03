.data
    # Movement directions (4-way: up, right, down, left)
d4x:                .word   0, 1, 0, -1
d4y:                .word   -1, 0, 1, 0

    # Or 8-way movement (includes diagonals)
d8x:                .word   0, 1, 1, 1, 0, -1, -1, -1
d8y:                .word   -1, -1, 0, 1, 1, 1, 0, -1

    # Message strings
mesg_path_found:    .asciiz "Path found!\n"
mesg_no_path:       .asciiz "No path exists.\n"
str_space:          .asciiz " "
node_str:           .asciiz "Node ["
comma:              .asciiz ","
wall_str:           .asciiz "] Wall: "
newline:            .asciiz "\n"

                    .eqv    x, 0
                    .eqv    y, 4
                    .eqv    wall, 8                         # 4 bytes
                    .eqv    gScore, 12
                    .eqv    hScore, 16
                    .eqv    fScore, 20
                    .eqv    parent_x, 24
                    .eqv    parent_y, 28
                    .eqv    gridWidth, 10
                    .eqv    gridHeight, 10
                    .eqv    displayWidth, 32                # Width of the display in units 512 / 32 = 16
                    .eqv    displayHeight, 32               # Height of the display in units 512 / 32 = 16
                    .eqv    gridCellWidth, 3                # Size of the display in bytes
                    .eqv    gridCellHeight, 3               # Size of the display in bytes
                    .eqv    bitmapBaseAddress, 0x10040000


map_width:          .word   10
map_height:         .word   10

    # Map data (0 = walkable, 1 = obstacle)
map_data:   .word   0, 0, 1, 1, 0, 0, 1, 1, 1, 1    # Row 0
            .word   1, 0, 1, 1, 0, 1, 1, 0, 0, 1    # Row 1
            .word   1, 0, 0, 0, 0, 1, 1, 0, 1, 1    # Row 2
            .word   1, 1, 1, 1, 0, 0, 0, 0, 1, 1    # Row 3
            .word   1, 1, 1, 0, 0, 1, 1, 0, 0, 1    # Row 4
            .word   1, 1, 0, 0, 1, 1, 1, 1, 0, 1    # Row 5
            .word   1, 0, 0, 1, 1, 0, 0, 1, 0, 1    # Row 6
            .word   1, 0, 1, 1, 0, 1, 0, 0, 0, 0    # Row 7
            .word   1, 0, 0, 0, 0, 1, 1, 1, 1, 0    # Row 8
            .word   1, 1, 1, 1, 1, 1, 1, 1, 1, 0    # Row 9

    # Start and goal positions
start_x:            .word   0
start_y:            .word   0
goal_x:             .word   9
goal_y:             .word   9

nodes:              .word   0:800                           # 25 nodes × 32 bytes
closed_set:         .word   0:100                           # 1 node × 32 bytes
node_size:          .word   32                              # Size of each node (32 bytes)
nodes_count:        .word   0                               # Number of nodes created

colorTable:
                    .word   0xDCDCDC                        # 0 - Path / Empty cell (Light Gray)
                    .word   0x2E2E2E                        # 1 - Wall (Charcoal)
                    .word   0x2ECC71                        # 2 - Start Point (Emerald Green)
                    .word   0xE74C3C                        # 3 - End Point (Red Orange)
                    .word   0x85C1E9                        # 4 - Visited Node (Sky Blue)
                    .word   0x9B59B6                        # 6 - Shortest Path (Royal Purple)