
forward_list_alt
================

A singly linked list container modelled on C++'s forward_list<> but with one difference.  The list handle also maintains a pointer to the tail of the list to allow O(1) push_back.  This container is implemented on top of forward_list to reuse as much code as possible.

Memory is neither allocated nor deallocated by the container -- that is the responsibility of the caller.

The list handle occupies four bytes and consists of a pointer to the first item in the list and a pointer to the last item in the list.

Items handled by the container must contain space for a next pointer and it is the address of this next pointer that is passed to the API when performing list operations.
