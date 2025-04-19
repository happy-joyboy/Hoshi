.data
# (x,y) coordinates of the node 
# wall: 1 if the node is a wall, 0 if it is not
# gScore: cost from start to this node
# hScore: estimated cost from this node to the goal
# fScore: gScore + hScore
# parent: pointer to the parent node in the path
# node: 4B x + 4B y + 4B wall + 4B gScore + 4B hScore + 4B fScore + 32B parent

# Node structure
node:        .space 60              # Entire node (for single node example)

# Offsets for fields within the node structure
# x:        0
# y:        4
# wall:     8   (using 4 bytes for alignment, you can change to 1 byte if optimizing for space)
# gScore:   12
# hScore:   16
# fScore:   20
# parent:   24   (32 bytes reserved)

# strings for printing
str_x:      .asciiz "x-coordinate: "
str_y:      .asciiz "\ny-coordinate: "
str_wall:   .asciiz "\nWall (1 = wall, 0 = not): "
str_weight: .asciiz "\nWeight: "
str_gScore: .asciiz "\ngScore: "
str_hScore: .asciiz "\nhScore: "
str_fScore: .asciiz "\nfScore: "
str_parent: .asciiz "\nParent address: "
str_newline:.asciiz "\n"
.text
.global main


node_push:
node_content:

    # Print x-coordinate
    la $a0, str_x
    li $v0, 4          
    syscall
    

