#ifndef FARMALLOC_H
#define FARMALLOC_H

#define HEAPSPACE __far

typedef struct header header_t;

struct header
{
        header_t * HEAPSPACE next; // Next block. Linked list of all blocks, terminated by pointer to end of heap (or to the byte beyond the end of the heap).
        header_t * HEAPSPACE next_free; // Next free block. Used in free blocks only. Overlaps with user data in non-free blocks. Linked list of free blocks, 0-terminated.
};

extern header_t *HEAPSPACE __far_heap;


extern void *__far malloc_far(size_t sz);
extern void *__far realloc_far(void *__far ptr, size_t sz);
extern void        free_far(void *__far ptr);


extern void *__far memmove_far(void *__far dst, const void *__far src, size_t len);
extern void *__far memcpy_far(void *__far dst, const void *__far src, size_t len);

#endif
