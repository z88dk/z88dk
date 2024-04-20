#include <sys/types.h>

#include <stdio.h>
#include "farmalloc.h"

header_t *__far __sdcc_heap_free; // First free block, 0 if no free blocks.


void farheap_add(void *__far ptr, size_t len)
{
    header_t *__far n = ptr;

    n->next = (unsigned long) ptr + (unsigned long)(len  - 1);
    n->next_free = NULL;

    if ( (long)__sdcc_heap_free == 0L ) {
        __sdcc_heap_free = n;
        printf("Heap free %lX\n",__sdcc_heap_free);
    } else {
        free_far((uint32_t)n+(uint32_t)3);

        // // Add it as a free block
        // header_t *__far h = __sdcc_heap_free;
        // while ( h->next_free )
        //    h = h->next_free;
        // printf("start %lX h=%lX\n",__sdcc_heap_free, h);
        // h->next_free = &n->next_free; 
    }
}
