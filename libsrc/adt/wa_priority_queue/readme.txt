
=================
wa_priority_queue
=================

A priority queue storing 16-bit words modelled on C++'s
priority_queue<word>.  wa_priority queue is an adapter of
ba_priority_queue.

The words are held in a special order that allows O(lg n)
in-order extraction from the queue.  w_array serves as the
underlying container of the priority queue's contents.

The leading "wa_" indicates that this container stores 16-bit
words using w_array as the container.

To create the priority queue, the caller supplies an 8-byte
wa_priority_queue_t structure to wa_priority_queue_init().  In
that call, the user specifies the address of the queue's data
array, its capacity in words and the comparison function to use.
The priority queue's initial size is set to zero but if the data
array contains valid words, the user can call wa_priority_queue_resize()
afterward to specify the number of valid words in the data array.
This call will also trigger a heapify operation to sort the valid
data into heap order.

The caller can perform all the operations specified in the C++
priority_queue API.  Since the underlying container is w_array,
the priority_queue is never allowed to grow larger than the array's
specified capacity.

The structure wa_priority_queue_t:

offset   size (bytes)   description

  0           2         int (*compar)(word *a, word *b), user supplied compare function
  2           2         void *data, the array of char held by w_array
  4           2         size_t size, number of occupied bytes in the data array
  6           2         capacity, full size of the data array in bytes

Note that wa_priority_queue_t is identical to ba_priority_queue_t.  All
sizes in the structure are measured in bytes, not words.  The
wa_priority_queue API is where conversion between words and bytes is made.


========
sections
========

seg_code_wa_priority_queue
