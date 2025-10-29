
========
wv_stack
========

A stack storing 16-bit words modelled on C++'s stack<word>.
w_vector serves as the underlying container of the stack's contents.

The leading "wv_" indicates that this container stores 16-bit words
using w_vector as the container.

wv_stack operates in exactly the same manner as wa_stack except
that the underlying container is w_vector.  This means wv_stack's
data array is allowed to grow via realloc as necessary.  The user
specifies a max_size for the w_vector so that the w_vector is not
allowed to realloc beyond a limit.

To create the stack, the caller supplies an 8-byte wv_stack_t
structure to wv_stack_init().  In that call, the user specifies
the stack's capacity and max_size in words.  The initializer will
allocate an initial data array of capacity size words and will
ensure that growth beyond max_size words is disallowed.  The
stack's initial size is zero.

See wa_stack for more information specific to stacks.  Some
additional functions are present to manage the underlying w_vector
which are described under w_vector's information.

The structure wv_stack_t:

offset   size (bytes)   description

  0           2         void *data, the array of char held by w_vector
  2           2         size_t size, number of occupied bytes in the data array
  4           2         capacity, malloc-allocation size of the data array in bytes
  6           2         max_size, the maximum malloc-allocation size for data in bytes

Note that wv_stack_t is identical to bv_stack_t.  All sizes in the
structure are measured in bytes, not words.  The wv_stack API is
where conversion between words and bytes is made.


========
sections
========

seg_code_wv_stack
