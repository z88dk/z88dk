
====
HEAP
====

The heap is a single contiguous block of memory out of which
variably-sized memory allocations can be made.  Its size is set
when the heap is initialized with a call to heap_init().

Any number of heaps can be created by the caller, including
heaps that exist in different memory banks.  It is the
responsibility of the programmer to ensure the heap is currently
paged in while it is being accessed.

When making calls through functions that do not supply a named
heap (eg malloc, realloc, etc), the thread's default heap is used.
This is a property of the thread's state so that different heaps
can be used for different threads transparently.

Starting with C11, the heap must be protected by a mutex.
Accordingly, all calls to the documented C functions first acquire
the mutex associated with the heap before proceeding.  All functions
also have an alternative non-standard version with "_unlocked"
appended to their names that allow access to the heap without first
acquiring the heap's mutex.  This may be useful if it is known no
other thread can access the heap simutaneously and it is these
functions that are aliased to when the non-threading version of the
library is built.

After initialization, the heap's data structure looks like this:

offset   size (bytes)   description

  0          6          mutex
  6          6          header
  12        ...         mem[] = available memory array
  ..         2          0 = heap terminator

The heap is framed by a mutex and 0 terminator.  In between is the
memory available for allocation.  As memory blocks are allocated,
various headers are inserted that keep track of what portions are
allocated and what portions are available.

The header format looks like this:

offset   size (bytes)   description

  0          2          next = pointer to next header
  2          2          committed = number of bytes allocated in this block + header size (0 if no allocation)
  4          2          prev = previous header. The first header uses
                        this word as the free-list head (see below).
  6         ...         mem[] = allocated plus unallocated memory padding to next header

The heap data type is very rich to allow full C11 compliance.  It
allows allocation, reallocation (growth or shrinking of an existing
block) and aligned allocation (allocating memory aligned to power of
two address).

Realloc, in particular, has been optimized to be quick when an existing
block can be resized in place.

The memory allocation strategy is first fit, except for realloc which
is largest fit.

malloc and free search an address-ordered list of spare tails. A
committed block with a tail of at least 7 bytes stores a 6-byte node
there (next, prev, owner). A committed value of 0 is not listed, so
the bytes at block+6 stay intact. malloc and largest-fit test the
first block on every call, which is where that hole lives. The first
header's prev word is the list head: 0 until the list is built, then
a node, or the address of the word itself when the list is empty.
Removing a tail splices that node from the prev and next words it
already holds, after the owner word and the neighbour link both name
this block. In-place realloc still compares the next header and does
not walk the live blocks.

A one-byte count of non-first committed == 0 holes lets largest-fit
trust the free list when the count is 0. The count may stay high
after one of those holes is allocated. A high count forces one
address-chain scan, and that scan writes the count again.

__CLIB_OPT_MALLOC in the target config selects this search. The
Malloc section of config_clib.m4 sets it. 1 is the spare-tail
search above. 0 is the address-chain walker: each call walks the
block headers, and that walker is the smaller program. The
library is built with 1. A different value takes effect when the
library is assembled again.


========
sections
========

seg_code_malloc


====
data
====

seg_data_malloc

__malloc_heap (void *)

Holds the address of the implied heap used by unnamed heap api
(malloc, realloc, calloc, free, etc). Externally supplied, section suggested.
