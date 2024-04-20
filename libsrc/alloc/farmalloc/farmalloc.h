#ifndef FARMALLOC_H
#define FARMALLOC_H

#include <stdlib.h>
#include <string.h>

typedef struct header header_t;

struct header
{
        header_t * __far next; // Next block. Linked list of all blocks, terminated by pointer to end of heap (or to the byte beyond the end of the heap).
        header_t * __far next_free; // Next free block. Used in free blocks only. Overlaps with user data in non-free blocks. Linked list of free blocks, 0-terminated.
};

extern header_t *__far __far_heap;

#endif
