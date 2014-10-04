
========
wa_stack
========

A stack storing 16-bit words modelled on C++'s stack<word>.  w_array
serves as the underlying container of the stack's contents.

The leading "wa_" indicates that this container stores 16-bit words
using w_array as the container.

To create the stack, the caller supplies a 6-byte wa_stack_t structure
to ba_stack_init().  In that call, the user speifies the address of
the stack's data array and its capacity in words.  The stack's initial
size is zero.

The caller can perform all the usual stack operations specified by
C++'s stack<word>.  Since the underlying container is w_array, the
stack is never allowed to grow larger than the array's specified
capacity.

The structure wa_stack_t:

offset   size (bytes)   description

  0           2         void *data, the array of char held by b_array
  2           2         size_t size, number of occupied bytes in the data array
  4           2         capacity, full size of the data array in bytes

Note that wa_stack_t is identical to ba_stack_t.  All sizes in the
structure are measured in bytes, not words.  The wa_stack API is where
conversion between words and bytes is made.


========
sections
========

seg_code_wa_stack
