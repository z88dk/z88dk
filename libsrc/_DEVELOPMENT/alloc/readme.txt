
Various memory allocators:


= block ==================

A block allocator that allocates fixed size blocks from queues of available blocks.  Fastest, one byte overhead per block, smallest code footprint, and no external fragmentation.  Main purpose is to efficiently handle frequently allocated and deallocated fixed size memory blocks.


= malloc =================

Implements the standard C malloc-related functions, able to allocate variable-size blocks from a heap.  Slowest, four bytes per block overhead, largest code footprint, suffers from external fragmentation.  Main purpose is to handle allocation requests of varying size.


= obstack ================

Gnu's obstack allocator allows allocation of objects in stack order and dynamic modification of the object on top of a stack.  Deallocation pops objects off this stack.  Fast, zero overhead per block, and medium code footprint.  Main purpose is to efficiently use memory for variable sized allocation in typical embedded environments where memory allocated to a task can be deallocated in one statement.
