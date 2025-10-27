
======
p_list
======

A doubly linked list container modelled on C++ list<>.

The leading "p_" indicates the container holds items
allocated by the caller and does not perform any
allocations or deallocations internally.

Items stored in the container must contain space for
two two-byte pointers.  A typical item might be laid
out like this:

offset   size (bytes)   description

   0           2        void *next
   2           2        void *prev
   4          ...       user data

The "next" and "prev" pointers are maintained by the
container.  When placing items into the container or
removing items from the container, the address of the
next pointer is what is communicated.

Creation of a p_list container involves reserving four
bytes to hold the list's head and tail.  In C:

p_list_t my_list;   // struct { void *head; void *tail; };

The list is initialized with a call to the container's
initializer:

p_list_init(&my_list);

The container is now empty and items can be added using
the container API.  Since the container performs no memory
allocation of its own, the user must have created and
allocated the item separately before adding it to the
container.

The "p_" family of containers all use space allocated
within user items to hold container state information.  Some
use two bytes and others use four bytes of state.  Items
with enough state space (two or four bytes) can be stored
in and moved between any of the "p_" family of containers.


========
sections
========

seg_code_p_list
