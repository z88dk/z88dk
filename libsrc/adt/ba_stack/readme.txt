
========
ba_stack
========

A stack storing bytes modelled on C++'s stack<char>.  b_array
serves as the underlying container of ba_stack.

The leading "ba_" indicates that this container stores bytes /
chars using b_array as the container.

To create the stack, the caller supplies a 6-byte ba_stack_t
structure to ba_stack_init().  In that call, the user speifies
the address of the stack's data array and its capacity.  The
stack's initial size is zero.

The caller can perform all the usual stack operations specified
by C++'s stack<char>.  Since the underlying container is b_array,
the stack is never allowed to grow larger than the array's
specified capacity.

The structure ba_stack_t:

offset   size (bytes)   description

  0           2         void *data, address of the array of char held by b_array
  2           2         size_t size, number of occupied bytes in the data array
  4           2         capacity, full size of the data array


========
sections
========

seg_code_ba_stack
