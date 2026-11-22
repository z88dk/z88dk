
=================
wv_priority_queue
=================

A priority queue storing 16-bit words modelled on C++'s
priority_queue<word>.

The words are held in a special order that allows O(lg n) in-order
extraction from the queue.  w_vector serves as the underlying
container of the priority queue's contents.

The leading "wv_" indicates that this container stores 16-bit
words using w_vector as the container.

wv_priority_queue operates in exactly the same manner as
wa_priority_queue except that the underlying container is a w_vector.
This means a wv_priority_queue's data array is allowed to grow via
realloc as necessary.  The user specifies a max_size for the b_vector
so that the b_vector is not allowed to realloc beyond a limit.

To create the priority queue, the caller supplies a 10-byte
wv_priority_queue_t structure to wv_priority_queue_init().  In that
call, the user specifies the queue's capacity in words, max_size
in words and the comparison function to use.  The initializer will
allocate an initial data array of capacity words size and will ensure
that growth beyond max_size words is disallowed.  The priority queue's
initial size is zero.

See wa_priority_queue for more information specific to priority queues.
Some additional functions are present to manage the underlying w_vector
which are described under w_vector's information.

The structure wv_priority_queue_t:

offset   size (bytes)   description

  0           2         int (*compar)(word *a, word *b), user supplied compare function
  2           2         void *data, the array of char held by w_vector
  4           2         size_t size, number of occupied bytes in the data array
  6           2         capacity, malloc-allocation size of the data array in bytes
  8           2         max_size, the maximum malloc-allocation size for data in bytes

Note that wv_priority_queue_t is identical to bv_priority_queue_t.  All
sizes in the structure are measured in bytes, not words.  The
wv_priority_queue API is where conversion between words and bytes is made.


========
sections
========

seg_code_wv_priority_queue
