
========
bv_stack
========

A stack storing bytes modelled on C++'s stack<char>.  b_vector
serves as the underlying container of the stack's contents.

The leading "bv_" indicates that this container stores bytes /
chars using b_vector as the container.

bv_stack operates in exactly the same manner as ba_stack except
that the underlying container is b_vector.  This means a bv_stack's
data array is allowed to grow via realloc as necessary.  The user
specifies a max_size for the b_vector so that the b_vector is not
allowed to realloc beyond a limit.

To create the stack, the caller supplies an 8-byte bv_stack_t
structure to bv_stack_init().  In that call, the user specifies
the stack's capacity and max_size.  The initializer will allocate
an initial data array of capacity size and will ensure that growth
beyond max_size bytes is disallowed.  The stack's initial size is
zero.

See ba_stack for more information specific to stacks.  Some
additional functions are present to manage the underlying b_vector
which are described under b_vector's information.

The structure bv_stack_t:

offset   size (bytes)   description

  0           2         void *data, address of the array of char held by b_vector
  2           2         size_t size, number of occupied bytes in the data array
  4           2         capacity, the malloc-allocation size of data
  6           2         max_size, the maximum malloc-allocation size for data


========
sections
========

seg_code_bv_stack
