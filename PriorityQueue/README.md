# 🚀 MIPS Priority Queue Implementation

<div align="center">

![Priority Queue Banner](https://raw.githubusercontent.com/username/mips-priority-queue/main/banner.png)

**A high-performance priority queue written in MIPS assembly language**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Assembly: MIPS](https://img.shields.io/badge/Assembly-MIPS-red.svg)](https://en.wikipedia.org/wiki/MIPS_architecture)

</div>

## 📋 Table of Contents

* [Overview](#-overview)
* [Features](#-features)
* [Implementation Details](#-implementation-details)
* [Usage](#-usage)
* [Functions Explained](#-functions-explained)
* [Data Structures](#-data-structures)
* [Example](#-example)
* [Performance](#-performance)
* [Contributing](#-contributing)
* [License](#-license)

## 🔍 Overview

This repository provides a complete **min-priority queue** implementation in MIPS assembly language, based on a binary heap data structure. It is designed to be used in algorithmic problems like A\* search and Dijkstra's algorithm, where fast retrieval and insertion based on priority are crucial.

## ✨ Features

* ⚡ **Efficient Runtime**: `O(log n)` complexity for `push` and `pop` operations
* 🔄 **Heap-Based Min-Priority Queue**: Ensures minimal `fScore` node stays at root
* 🧠 **Each Node Contains**:

  * `(x, y)` coordinates
  * `parent` node reference
  * `fScore` (priority metric)
* 🖥️ **Debugging Utilities**: `print_heap` and `print_EX_node` functions
* 🔍 **Node Lookup**: `find_node` enables searching nodes by coordinates

## 🔧 Implementation Details

### Heap Structure

Nodes are arranged in a binary heap using a linear array. Each node occupies **16 bytes**:

```
Offset  Field     Size (bytes)
0       x         4
4       y         4
8       parent    4
12      fScore    4
```

This structure ensures the smallest `fScore` node is always at index `0`, with child nodes following the binary heap rule.

### Binary Heap Properties

* Left child index: `2*i + 1`
* Right child index: `2*i + 2`
* Parent index: `(i - 1) / 2`

Heap operations like bubbling up/down are implemented to maintain this structure.

## 🚀 Usage

1. Include required assembly files:

```assembly
.include "data_pq.asm"
.include "pq_functions.asm"
```

2. Use the API:

```assembly
# Push a node into the priority queue
li $a0, 5          # x
li $a1, 10         # y
li $a2, 0          # parent
li $a3, 15         # fScore
jal push

# Pop the node with the lowest fScore
jal pop
jal print_EX_node  # Display the extracted node
```

## 📚 Functions Explained

### `push`

Inserts a node into the priority queue.

#### Inputs:

* `$a0` = x coordinate
* `$a1` = y coordinate
* `$a2` = parent reference
* `$a3` = fScore

#### Steps:

1. Check if the heap is full.
2. Store the new node at the end of the heap.
3. Increment `heapSize`.
4. Perform **bubble-up** to restore min-heap property:

   * Swap with parent until the `fScore` is greater than or equal to the parent's.

### `pop`

Removes and returns the node with the lowest `fScore`.

#### Returns:

* Stores the extracted node in the `extracted_node` memory location.

#### Steps:

1. If the heap is empty, print a message and exit.
2. Copy the root node to `extracted_node`.
3. Move the last element to root.
4. Decrement `heapSize`.
5. Perform **bubble-down**:

   * Compare the current node with its children.
   * Swap with the smaller child until heap property is restored.

### `print_heap`

Prints all nodes in the heap for visualization and debugging.

### `print_EX_node`

Displays the last extracted node after a `pop` operation.

### `find_node`

Finds a node in the heap by coordinates.

#### Inputs:

* `$a0` = x coordinate
* `$a1` = y coordinate

#### Output:

* `$v0` = address of node if found; 0 if not found

#### Process:

* Iterates through the heap and compares stored x and y values with input.

## 🏗️ Data Structures

Defined in `data_pq.asm`:

```assembly
.data
heap:           .space 1600          # Space for 100 nodes (16 bytes each)
heapSize:       .word 0              # Current node count
heap_capacity:  .word 100            # Max nodes
extracted_node: .space 16            # Storage for popped node

# A* Node tracking
nodes:          .space 4000          # Additional node storage
nodes_count:    .word 0
node_size:      .word 24

# Node field offsets
x:              .word 0
y:              .word 4
parent:         .word 8
fScore:         .word 12

# Messages
msg_heap_full:  .asciiz "Heap is full\n"
msg_heap_empty: .asciiz "Heap is empty\n"
msg_coma:       .asciiz ", "
newline:        .asciiz "\n"
```

## 🔄 Example

```assembly
.include "data_pq.asm"
.include "pq_functions.asm"

.text
main:
    li $a0, 1
    li $a1, 2
    li $a2, 0
    li $a3, 10
    jal push

    li $a0, 3
    li $a1, 4
    li $a2, 0
    li $a3, 5
    jal push

    jal print_heap
    jal pop
    jal print_EX_node

    li $v0, 10
    syscall
```

## 📊 Performance

| Operation | Time Complexity |
| --------- | --------------- |
| `push`    | O(log n)        |
| `pop`     | O(log n)        |
| `peek`    | O(1)            |

## 🤝 Contributing

Feel free to fork the repo, suggest changes, and submit pull requests! Bug reports and improvements are welcome.

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

<div align="center">
  Made with ❤️ by [Your Name or Alias]  
  ![Heap Visualization](https://raw.githubusercontent.com/username/mips-priority-queue/main/heap-visualization.png)
</div>
