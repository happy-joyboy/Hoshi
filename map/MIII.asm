# M III :   5×5 With Walls and Diagonal Movement

# Map layout:
# +---+---+---+---+---+
# | S |   |   | W |   |
# +---+---+---+---+---+
# |   | W | W | W |   |
# +---+---+---+---+---+
# |   |   |   | W |   |
# +---+---+---+---+---+
# | W | W | W | W |   |
# +---+---+---+---+---+
# |   |   |   |   | G |
# +---+---+---+---+---+

# S = Start position (0,0)
# G = Goal position (4,4)

.data
# Map dimensions
map_width:    .word 5
map_height:   .word 5

# Map data (0 = walkable, 1 = obstacle)
map_data:     .word 0, 0, 0, 1, 0,   # Row 0
                    0, 1, 1, 1, 0,   # Row 1
                    0, 0, 0, 0, 0,   # Row 2
                    1, 0, 1, 1, 0,   # Row 3
                    0, 0, 0, 0, 0    # Row 4

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 4
goal_y:       .word 4

# 8-way movement (includes diagonals)
dx:           .word 0, 1, 1, 1, 0, -1, -1, -1
dy:           .word -1, -1, 0, 1, 1, 1, 0, -1