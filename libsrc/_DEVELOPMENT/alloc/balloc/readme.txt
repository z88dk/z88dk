
========================
BLOCK ALLOCATOR (BALLOC)
========================

The block allocator maintains an array of linked lists of available
memory blocks.  Each array index's linked list contains blocks of
the same size.  It is suggested that the size of the blocks increase
with array index to be compatible with balloc_firstfit().

The programmer is responsible for adding available memory blocks to
each index.  This memory can come from anywhere, including memory in
different banks.  It is the responsibility of the programmer to
ensure the appropriate bank and the allocator array is paged in when
a block is allocated or freed.

The allocator array is a property of the thread and can be swapped
out on context switch.

Block allocation and deallocation is very quick and has no external
fragmentation.  Each allocated block does incur a one byte overhead
to identify the array index the block belongs to.  For these reasons,
block allocation is an attractive alternative to the heap for frequent
allocation of small fixed-size blocks.


========
sections
========

seg_code_balloc


====
data
====

seg_data_balloc

__balloc_array (void *)

Holds a pointer to the currently active balloc array.
Externally supplied, section suggested.
