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
                    .eqv    wall, 8                                         # 4 bytes
                    .eqv    gScore, 12
                    .eqv    hScore, 16
                    .eqv    fScore, 20
                    .eqv    parent_x, 24
                    .eqv    parent_y, 28
                    .eqv    gridWidth, 16
                    .eqv    gridHeight, 16
                    .eqv    displayWidth, 16                                # Width of the display in units 512 / 32 = 16
                    .eqv    displayHeight, 16                               # Height of the display in units 512 / 32 = 16
                    .eqv    gridCellWidth, 1                                # Size of the display in bytes
                    .eqv    gridCellHeight, 1                               # Size of the display in bytes
                    .eqv    bitmapBaseAddress, 0x10040000


map_width:          .word   16
map_height:         .word   16

    # Map     data,   1 = obstacle)
map_data:
                    .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 0
                    .word   0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 1
                    .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 2
                    .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 3
                    .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 4
                    .word   0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 5
                    .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 6
                    .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 7
                    .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 8
                    .word   0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 9
                    .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 10
                    .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 11
                    .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 12
                    .word   0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 13
                    .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 14
                    .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 15

    # Start   and
    # Start   and
start_x:            .word   0
start_y:            .word   0
goal_x:             .word   15
goal_y:             .word   15

nodes:              .word   0:2048                                          # 64 nodes × 32 bytes
closed_set:         .word   0:256                                           # 1 node × 32 bytes
node_size:          .word   32                                              # Size of each node (32 bytes)
nodes_count:        .word   0                                               # Number of nodes created

colorTable:
                    .word   0xDCDCDC                                        # 0 - Path / Empty cell (Light Gray)
                    .word   0x2E2E2E                                        # 1 - Wall (Charcoal)
                    .word   0x2ECC71                                        # 2 - Start Point (Emerald Green)
                    .word   0xE74C3C                                        # 3 - End Point (Red Orange)
                    .word   0x85C1E9                                        # 4 - Visited Node (Sky Blue)
                    .word   0x9B59B6                                        # 5 - Shortest Path (Royal Purple)
                    .word   0xF1C40F                                        # 6 - Open Node (Sunflower Yellow)








    # map_width:          .word   32
    # map_height:         .word   32

    #     # 32x32 Map data (0 = walkable, 1 = obstacle)
    # map_data:
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 0
    #                     .word   0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 1
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 2
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 3
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 4
    #                     .word   0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 5
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 6
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 7
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 8
    #                     .word   0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 9
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 10
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 11
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 12
    #                     .word   0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 13
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 14
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 15
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 16
    #                     .word   0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 17
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 18
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 19
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 20
    #                     .word   0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 21
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 22
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 23
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 24
    #                     .word   0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  # Row 25
    #                     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Row 26
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 27
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 28
    #                     .word   0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  # Row 29
    #                     .word   0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  # Row 30
    #                     .word   1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0  # Row 31

    #     # Start and goal positions
    # start_x:            .word   0
    # start_y:            .word   0
    # goal_x:             .word   31
    # goal_y:             .word   31

    # nodes:              .word   0:9216                                                                                          # 64 nodes × 32 bytes
    # closed_set:         .word   0:1024                                                                                          # 1 node × 32 bytes
    # node_size:          .word   32                                                                                              # Size of each node (32 bytes)
    # nodes_count:        .word   0                                                                                               # Number of nodes created


    #     #############################################################################################################

    #     ################################################################################################

    #     # bitmap_helper data

    # .data
    #                     .eqv    displayWidth, 32                                                                                # Width of the display in units 1024 / 32 = 32
    #                     .eqv    displayHeight, 32                                                                               # Height of the display in units 1024 / 32 = 32
    #                     .eqv    gridCellWidth, 1                                                                                # Size of the display in bytes
    #                     .eqv    gridCellHeight, 1                                                                               # Size of the display in bytes
    #                     .eqv    gridWidth, 32
    #                     .eqv    gridHeight, 32
    #                     .eqv    bitmapBaseAddress, 0x10040000