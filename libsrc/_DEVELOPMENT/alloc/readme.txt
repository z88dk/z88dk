
Various memory allocators:


= block ==================

A block allocator that allocates fixed size blocks from queues of available blocks.  Fastest and one byte overhead per block.


= malloc =================

Implements the standard C malloc-related functions, able to allocate variable-size blocks from a heap.  Slowest and four bytes per block overhead.


= obstack ================

Gnu's obstack allocator allows allocation and modification of the object on top of a stack.  Deallocation pops objects off this stack.  Fast and zero overhead per block.

