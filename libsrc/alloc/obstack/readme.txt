
=======
OBSTACK
=======

An obstack is a single contiguous block of memory out of which
variably-sized objects are allocated in sequential order.  It
can be thought of as an object-stack on which objects are grown
one after the other.  The obstack's size is set when it is
initialized in the call to obstack_init().

Any number of obstacks can be created by the caller, including
obstacks in different memory banks.  It is the responsibility
of the programmer to ensure the obstack is currently paged in
while it is being accessed.

The interface supplies functions that allow allocations to occur
from the top of the obstack and to allow incrementally building
up the object on the top of the obstack.  Stdio also supplies an
obstack_printf() function to append data to the currently growing
object.

When an object is freed, the object as well as all objects
allocated after it are freed.  Freeing amounts to setting a new
address from which future objects are allocated.

Obstack allocation is very quick and has no overhead.  Since
objects are allocated sequentially, there is also no fragmentation
or overhead.  These features, together with the reset nature of
freeing, make the obstack an attractive choice for memory allocation
in embedded systems.

The obstack consists of a six-byte header followed by a block of
available memory.

offset   size (bytes)   description

   0           2        fence = next available address in obstack
   2           2        object = start address of currently growing object
   4           2        end = address of byte following the obstack block
   6          ...       mem[] = available memory


========
sections
========

seg_code_obstack
