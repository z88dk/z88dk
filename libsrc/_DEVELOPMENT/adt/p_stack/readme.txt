
=======
p_stack
=======

A LIFO stack modelled on C++ stack<>.

The leading "p_" indicates the container holds items allocated
by the caller and does not perform any allocations or
deallocations internally.

Items stored in the container must contain space for a
two-byte pointer.  A typical item might be laid out like
this:

offset   size (bytes)   description

   0           2        void *next
   4          ...       user data

The "next" pointer is maintained by the container.  When
placing items into the container or removing items from the
container, the address of the next pointer is what is
communicated.

Creation of a p_stack container involves reserving two bytes to
hold the stack's head.  In C:

p_stack_t my_stack;   // void *stack;

The stack is initialized with a call to the container's
initializer:

p_stack_init(&my_stack);

The container is now empty and items can be added using the
container API.  Since the container performs no memory
allocation of its own, the user must have created and allocated
the item separately before adding it to the container.

The "p_" family of containers all use space allocated within
user items to hold container state information.  Some use two
bytes and others use four bytes of state.  Items with enough
state space (two or four bytes) can be stored in and moved
between any of the "p_" family of containers.


========
sections
========

seg_code_p_stack
