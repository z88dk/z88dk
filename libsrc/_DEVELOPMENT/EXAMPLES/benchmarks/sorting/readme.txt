SORT
====

This benchmark test the performance of the compiler library's qsort function.

Some of the C compilers under test do not supply a qsort() function so for those
a common & small implementation has been sourced from the internet.  Unfortunately
the kind of subroutine that one might commonly source from the internet quite often
has poor edge case performance.  However we stick with that because that is likely
what most users will use after realizing a compiler's library implementation is
incomplete.

To test the quality of the implementation, common cases and edge cases are tested:

1. Items are initially in random order.
2. Items are already sorted.
3. Items are in reverse order.
4. Items are all equal.

For each test case above, two scenarios are considered: sorting a small number of
items (20) and sorting a large number of items (5000).

The new c library Z88DK case is more difficult to test.  It allows the library to
be customized to select which sorting algorithm qsort uses from shellsort, insertion
sort and quicksort.  By default the library supplies shellsort.  The quicksort
implementation can be further customized to determine pivot selection (middle or random),
whether insertion sort is used for small partitions, and if equal items are dispersed
approximately equally between partitions.  The new c library also has a heapsort
implementation through the priority_queue data type but that cannot be connected to
the qsort function.  For Z88DK testing then, only a few combinations are chosen to
keep the number of variations under control.

RESULTS - 20 ITEMS
==================



RESULTS - 5000 ITEMS
====================
