# Mark I
# Map layout:
# +---+---+---+---+---+
# | S |   |   |   | G |
# +---+---+---+---+---+

# S = Start position (0,0)
# G = Goal position (0,4)
# Empty spaces are walkable

#     SOL     #
# The path should be: (0,0) → (1,0) → (2,0) → (3,0) → (4,0)

.data
# Map dimensions
map_width:    .word 5
map_height:   .word 1

# Map data (0 = walkable, 1 = obstacle)
map_data:     .word 0, 0, 0, 0, 0

# Start and goal positions
start_x:      .word 0
start_y:      .word 0
goal_x:       .word 4
goal_y:       .word 0

