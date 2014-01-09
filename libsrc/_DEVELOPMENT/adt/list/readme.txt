
list
====

A doubly linked list container modelled on C++'s list<>.

Memory is neither allocated nor deallocated by the container -- that is the responsibility of the caller.

The list handle occupies four bytes and is simply a pointer to the first item in the list and the last item in the list.

Items handled by the container must contain space for a next pointer and a previous pointer and it is the address of this next pointer that is passed to the API when performing list operations.
