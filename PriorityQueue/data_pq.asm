.data
# # Priority Queue DS
# (each node: 12 bytes = 4B x + 4B y + 4B fScore)
heap: .space 1200 # 100-node heap 
heapSize: .word 0 # Current Number of nodes in the heap
heap_capacity: .word 100 # Maximum number of nodes in the heap = 1200 / 12
extracted_node: .space 12
# Messages
msg_heap_full: .asciiz "Heap is full. Cannot insert.\n"
msg_heap_empty: .asciiz "Heap is empty.\n"
msg_extract: .asciiz "Extracted node: "
popcorn: .asciiz "pop pop pop.....\n"
message_coma: .asciiz ", "
newline: .asciiz "\n"


# dont include this file multile times or it will error
#The error Recursive include of file occurs because the file data_pq.asm is being included multiple times, either directly or indirectly, creating a recursive loop.