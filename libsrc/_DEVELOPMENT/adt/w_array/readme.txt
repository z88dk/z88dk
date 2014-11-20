
=======
w_array
=======

A fixed size array of 16-bit words having similar operations as
w_vector.  w_array is an adapter of b_array and serves as the
underlying type of w_vector.

The leading "w_" indicates this container stores 16-bit words.

To create the container, the caller supplies a 6-byte w_array_t
structure to w_array_init().  In that call, the user specifies
the address of the array's data and its capacity in words.  The
array's size is set to zero but if the data array contains valid
words, the user can manually set the size member after calling
w_array_init().

The caller can insert, append and erase words from the array
using a C++-like vector<char> API.  However, the array is never
allowed to grow larger than its capacity, making it ideal as a
wrapper for statically allocated C-arrays.

As with C++'s vector<word>, a pointer to the data portion of the
array can be retrieved and direct, fast access to elements can be
done using standard C array indexing.

The structure w_array_t:

offset   size (bytes)   description

  0           2         void *data, the address of the array of char held by w_array
  2           2         size_t size, number of occupied bytes in the data array (even!)
  4           2         capacity, full size of the data array in bytes (even!)

Note that w_array_t is identical to b_array_t.  All sizes in the
structure are measured in bytes, not words.  The w_array API is
where the conversion between words and bytes is made.


========
sections
========

seg_code_w_array
