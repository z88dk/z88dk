
b_vector
========

A resizeable byte array modelled on C++ vector<char>.

The leading "b_" indicates this container stores bytes / chars.

To create the container, the caller supplies an 8-byte b_vector_t structure to b_vector_init().  In that call, the user also specifies the vector's initial capacity in bytes and its maximum size.

The caller can insert, append and erase bytes from the vector using a C++-like API.  If the number of chars placed in the vector exceeds its current capacity, the array managed by vector is resized through calls to realloc to make space.  The array is not allowed to grow larger than the max_size specified when the vector was created.

As with the C++ container, a pointer to the array held by the vector can be retrieved and direct, fast access to elements can be done using standard C array indexing.  Likewise, the vector's array can be directly initialized by first resizing it to the size required and then retrieving a pointer to the vector's array.

The vector structure b_vector_t:

offset   size (bytes)   description

  0           2         void *array, array managed by vector
  2           2         size_t size, number of occupied bytes in vector
  4           2         capacity, allocated size of array
  6           2         max_size, maximum allocation for array
