
=======
b_array
=======

A fixed size array having similar operations as b_vector.
b_array serves as the underlying type of b_vector.

The leading "b_" indicates this container stores bytes / chars.

To create the container, the caller supplies a 6-byte b_array_t
structure to b_array_init().  In that call, the user specifies
the address of the array's data and its capacity.  The array's
size is set to zero but if the data array contains valid bytes,
the user can manually set the size member after calling
b_array_init().

The caller can insert, append and erase bytes from the array
using a C++-like vector<char> API.  However, the array is never
allowed to grow larger than its capacity, making it ideal as a
wrapper for statically allocated C-arrays.

As with C++'s vector<char>, a pointer to the data portion of
the array can be retrieved and direct, fast access to elements
can be done using standard C array indexing.

The structure b_array_t:

offset   size (bytes)   description

  0           2         void *data, address of the array of char held by b_array
  2           2         size_t size, number of occupied bytes in the data array
  4           2         capacity, the maximum size of the data array


========
sections
========

seg_code_b_array
