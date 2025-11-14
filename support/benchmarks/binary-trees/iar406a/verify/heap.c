/*                               - HEAP.C -

   Storage for "malloc".

   To modify the heap size, see the user documentation

   The heap size is controlled by the value of the symbol MALLOC_BUFSIZE.

   $Name: V3_34K $          

   Copyright 1986 - 1999 IAR Systems. All rights reserved.
*/

#include "memstruc.i"

#ifndef MALLOC_BUFSIZE
#define MALLOC_BUFSIZE 20000
#endif

/* Get number of align buckets from number of bytes */
#define __NR_ELEMENTS__ (__HEAP_SIZE__(MALLOC_BUFSIZE))

/* Allocate the actual heap, */
static MEM_ATTRIBUTE __align_union__ bulk_storage[__NR_ELEMENTS__];

/* a pointer to the first byte */
char PTR_ATTRIBUTE *const _heap_of_memory = (char PTR_ATTRIBUTE *) 
                                            bulk_storage;

/* a pointer to still free heap memory, */
char PTR_ATTRIBUTE *_last_heap_object = (char PTR_ATTRIBUTE *) bulk_storage;

/* and a pointer to last byte in the heap */
char PTR_ATTRIBUTE *const _top_of_heap = (char PTR_ATTRIBUTE *)
                                         (bulk_storage + __NR_ELEMENTS__ - 1);



