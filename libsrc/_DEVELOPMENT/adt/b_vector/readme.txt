
========
b_vector
========

A resizeable byte array modelled on C++ vector<char>.

The leading "b_" indicates this container stores bytes / chars.

To create the container, the caller supplies an 8-byte b_vector_t
structure to b_vector_init().  In that call, the user also specifies
the vector's initial capacity in bytes and its maximum size.  The
initializer will allocate a data array of size capacity bytes and
the vector's initial size is set to zero.

The caller can insert, append and erase bytes from the vector
using a C++-like API.  If the number of chars placed in the vector
exceeds its current capacity, the array managed by vector is resized
through calls to realloc to make space.  The array is not allowed to
grow larger than the max_size specified when the vector was created.

As with the C++ container, a pointer to the array held by the vector
can be retrieved and direct, fast access to elements can be done
using standard C array indexing.  Likewise, the vector's array can
be directly initialized by first resizing it to the size required
and then retrieving a pointer to the vector's array.

The structure b_vector_t:

offset   size (bytes)   description

  0           2         void *data, the address of the array of chars held by b_vector
  2           2         size_t size, number of occupied bytes in data
  4           2         capacity, the malloc-allocated size of data
  6           2         max_size, the maximum malloc-allocation size of data


========
sections
========

seg_code_b_vector
