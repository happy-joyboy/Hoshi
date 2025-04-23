# Mark II : 3×3 With Walls (4-Direction Movement)
# Map layout:
# +---+---+---+
# | S | W |   |
# +---+---+---+
# |   | W |   |
# +---+---+---+
# |   |   | G |
# +---+---+---+

# S = Start position (0,0)
# G = Goal position (2,2)
# W = Wall/obstacle (1,0), (1,1)
# Empty spaces are walkable



.data
# Map dimensions
map_width:    .word 3
map_height:   .word 3

# Map data (0 = walkable, 1 = obstacle)
map_data:     .word 0, 1, 0,   # Row 0
                    0, 1, 0,   # Row 1
                    0, 0, 0    # Row 2

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 2
goal_y:       .word 2