

.text
.globl main
main:
    # Initialize nodes
    jal initialize_nodes
    
    jal     print_node_grid
    
    # Print node grid with heuristic values
    # jal print_node_grid_with_h
    
    # Exit program
    li $v0, 10
    syscall

.include    "node_list.asm"
.include    "..\map\MII.asm"

