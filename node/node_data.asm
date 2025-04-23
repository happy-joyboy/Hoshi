.data
str_space:      .asciiz " "
str_newline:    .asciiz "\n"

nodes:          .space  3200                                 # 9 nodes × 36 bytes
node_size:      .word   32                                    # Size of each node (36 bytes)
nodes_count:    .word   0                                   # Number of nodes created
    # Offsets for fields within the node structure
                .eqv    x, 0
                .eqv    y, 4
                .eqv    wall, 8                             # 4 bytes
                .eqv    gScore, 12
                .eqv    hScore, 16
                .eqv    fScore, 20
                .eqv    parent_x, 24
                .eqv    parent_y, 28


node_str:       .asciiz "Node ["
comma:          .asciiz ","
wall_str:       .asciiz "] Wall: "
newline:        .asciiz "\n"