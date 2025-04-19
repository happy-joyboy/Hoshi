.data
str_space:  .asciiz " "
str_newline:.asciiz "\n"

# 3x3 nested array
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

nodes: .space 270  # Space for 9 nodes (3x3 grid, each node is 60 bytes)
node_size: .word 30 # Size of each node in bytes to be used as offset
nodes_count: .word 0 # Number of nodes created
# Offsets for fields within the node structure
x:      .word        0
y:      .word        4
wall:   .word        8     #(using 4 bytes for alignment, you can change to 1 byte if optimizing for space)
gScore: .word        9
hScore: .word        13
fScore: .word        17
parent_x: .word      21
parent_y: .word      25   

.text

main:


    # Loop through the map data to create nodes

node_adder:
    lw $t0, nodes                   # Load base address of nodes
    lw $t5, map_data

    lw $t0, map_height               # Load map height
    lw $t1, map_width                # Load map width

    li $t2, 0                         # Row counter

    move_row:
        beq $t2, $t1, _done  # If row counter equals row count, exit loop

        li $t3, 0                         # Column counter

    move_col:
        beq $t3, $t1, next_row # If column counter equals column count, go to next row

        # calc address of the node & map
        mul $t4, $t2, $t1                # t4 = row * map_width
        add $t4, $t4, $t3                # t4 = row * map_width + col
        sll $t4, $t4, 2                  # t4 = (row * map_width + col) * 4
        
        add $t5, $t4, $t5               # t5 = base + (row * map_width + col) * 4  -> map address
        add $t4, $t4, $t0                # t4 = base + (row * map_width + col) * 4 -> node address

        sw
        
        
        lw $t6, node_size
        add $t4, $t4, $t6               # t4 = node address + node size 
        addi $t3, $t3, 1            # Increment column counter
        
        lw $t6, nodes_count
        addi $t6, $t6, 1
        sw $t6, nodes_count
        
        j move_col

    next_row:
        li $v0, 4
        la $a0, str_newline
        syscall
        addi $t3, $t3, 1
        j move_row

_done:
    jr $ra