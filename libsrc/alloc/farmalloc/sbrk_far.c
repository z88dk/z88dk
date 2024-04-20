#include <sys/types.h>

#include <stdio.h>
#include "farmalloc.h"

header_t *__far __far_heap; // First free block, 0 if no free blocks.


void sbrk_far(void *__far ptr, size_t len)
{
    header_t *__far n = ptr;

    n->next = (void *__far)((char *__far)ptr + (uint32_t)(len  - 1));
    n->next_free = NULL;

    if ( __far_heap == NULL ) {
        __far_heap = n;
    } else {
        free_far((void *__far)((char *__far)n+(uint32_t)3));
    }
}
