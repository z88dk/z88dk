#include <sys/types.h>

#include "farmalloc.h"

header_t *__far __sdcc_heap_free; // First free block, 0 if no free blocks.


void farheap_add(void *__far ptr, size_t len)
{
    header_t *__far n = ptr;

    n->next = (void * __far)(char * __far ) ptr + (len  - 1);
    n->next_free = NULL;

    if ( __sdcc_heap_free == NULL ) {
        __sdcc_heap_free = n;
    } else {
        // Add it as a free block
        header_t *__far h;
        while ( h->next_free )
           h = h->next_free;
        h->next_free = n;         
    }
}
