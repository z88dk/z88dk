
=================
bv_priority_queue
=================

A priority queue storing bytes modelled on C++'s priority_queue<char>.

The bytes are held in a special order that allows O(lg n) in-order
extraction of the bytes from the queue.  b_vector serves as the
underlying container of the priority queue's contents.

The leading "bv_" indicates that this container stores bytes / chars
using b_vector as the container.

bv_priority_queue operates in exactly the same manner as
ba_priority_queue except that the underlying container is a b_vector.
This means a bv_priority_queue's data array is allowed to grow via
realloc as necessary.  The user specifies a max_size for the b_vector
so that the b_vector is not allowed to realloc beyond a limit.

To create the priority queue, the caller supplies a 10-byte
bv_priority_queue_t structure to bv_priority_queue_init().  In that
call, the user specifies the queue's capacity, max_size and the
comparison function to use.  The initializer will allocate an initial
data array of capacity size and will ensure that growth beyond
max_size bytes is disallowed.  The priority queue's initial size is
zero.

See ba_priority_queue for more information specific to priority queues.
Some additional functions are present to manage the underlying b_vector
which are described under b_vector's information.

The structure bv_priority_queue_t:

offset   size (bytes)   description

  0           2         int (*compar)(char *a, char *b), user supplied compare function
  2           2         void *data, address of the array of char held by b_vector
  4           2         size_t size, number of occupied bytes in the data array
  6           2         capacity, the malloc-allocation size of the data array
  8           2         max_size, the maximum malloc-allocation size for data


========
sections
========

seg_code_bv_priority_queue
