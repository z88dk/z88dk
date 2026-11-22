
=================
ba_priority_queue
=================

A priority queue storing bytes modelled on C++'s priority_queue<char>.

The bytes are held in a special order that allows O(lg n) in-order
extraction of the bytes from the queue.  b_array serves as the
underlying container of the priority queue's contents.

The leading "ba_" indicates that this container stores bytes / chars
using b_array as the container.

To create the priority queue, the caller supplies an 8-byte
ba_priority_queue_t structure to ba_priority_queue_init().  In that
call, the user specifies the address of the queue's data array, its
capacity and the comparison function to use.  The priority queue's
initial size is set to zero but if the data array contains valid
bytes, the user can call ba_priority_queue_resize() afterward to
specify the number of valid bytes in the data array.  This call
will also trigger a heapify operation to sort the valid data into
heap order.

The caller can perform all the operations specified in the C++
priority_queue API.  Since the underlying container is b_array, the
priority_queue is never allowed to grow larger than the array's
specified capacity.

The structure ba_priority_queue_t:

offset   size (bytes)   description

  0           2         int (*compar)(char *a, char *b), user supplied compare function
  2           2         void *data, the address of the array of char held by b_array
  4           2         size_t size, number of occupied bytes in the data array
  6           2         capacity, the full size of the data array


========
sections
========

seg_code_ba_priority_queue
