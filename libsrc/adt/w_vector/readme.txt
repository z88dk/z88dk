
w_vector
========

A resizeable word array modelled on C++ vector<void*>.

The leading "w_" indicates this container stores two-byte words.

w_vector is an adapter of b_vector and, like b_vector, is
represented by an 8-byte w_vector_t structure.  This structure
is in fact identical to b_vector_t with all members representing
quantities in bytes.  It is the w_vector_* API that multiplies
indexes and sizes by two as appropriate to interpret indices in
terms of words.

To create the container, the caller supplies an 8-byte w_vector_t
structure to w_vector_init().  In that call, the user also
specifies the vector's initial capacity in words and its maximum
size in words.

The caller can insert, append and erase words from the vector
using a C++-like API.  If the number of words placed in the vector
exceeds its current capacity, the array managed by vector is
resized through calls to realloc to make space.  The array is not
allowed to grow larger than the max_size specified when the
vector was created.

As with the C++ container, a pointer to the array held by the
vector can be retrieved and direct, fast access to elements can
be done using standard C array indexing.  Likewise, the vector's
array can be directly initialized by first resizing it to the size
required and then retrieving a pointer to the vector's array.

The vector structure w_vector_t:

offset   size (bytes)   description

  0           2         void *data, the address of the array managed by vector
  2           2         size_t size, number of occupied bytes in the data array
  4           2         capacity, malloc-allocated size of the data array in bytes
  6           2         max_size, maximum malloc-allocation for data in bytes

Note that w_vector_t is identical to b_vector_t.


========
sections
========

seg_code_w_vector
