include(__link__.m4)

#ifndef _ALLOC_MALLOC_H
#define _ALLOC_MALLOC_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct heap_info_s
{

   int     type;     // 0 = HEADER, 1 = ALLOCATED, 2 = FREE
   void   *address;
   size_t  size;

} heap_info_t;

// expose pointer to malloc heap
extern unsigned char *_malloc_heap;

__DPROTO(,,void,*,_falloc_,void *p,size_t size)
__DPROTO(,,void,*,heap_alloc,void *heap,size_t size)
__DPROTO(,,void,*,heap_alloc_aligned,void *heap,size_t alignment,size_t size)
__DPROTO(,,void,*,heap_alloc_fixed,void *heap,void *p,size_t size)
__DPROTO(,,void,*,heap_calloc,void *heap,size_t nmemb,size_t size)
__DPROTO(,,void,*,heap_destroy,void *heap)
__DPROTO(`b,c',`b,c',void,,heap_free,void *heap,void *p)
__DPROTO(,,void,,heap_info,void *heap,void *callback)
__DPROTO(,,void,*,heap_init,void *heap,size_t size)
__DPROTO(,,void,*,heap_realloc,void *heap,void *p,size_t size)
__DPROTO(,,void,*,memalign,size_t alignment,size_t size)
__DPROTO(,,int,,posix_memalign,void **memptr,size_t alignment,size_t size)

__DPROTO(,,void,*,_falloc__unlocked,void *p,size_t size)
__DPROTO(,,void,*,heap_alloc_unlocked,void *heap,size_t size)
__DPROTO(,,void,*,heap_alloc_aligned_unlocked,void *heap,size_t alignment,size_t size)
__DPROTO(,,void,*,heap_alloc_fixed_unlocked,void *heap,void *p,size_t size)
__DPROTO(,,void,*,heap_calloc_unlocked,void *heap,size_t nmemb,size_t size)
__DPROTO(`b,c',`b,c',void,,heap_free_unlocked,void *heap,void *p)
__DPROTO(,,void,,heap_info_unlocked,void *heap,void *callback)
__DPROTO(,,void,*,heap_realloc_unlocked,void *heap,void *p,size_t size)
__DPROTO(,,void,*,memalign_unlocked,size_t alignment,size_t size)
__DPROTO(,,int,,posix_memalign_unlocked,void **memptr,size_t alignment,size_t size)

#ifndef _STDLIB_H

__DPROTO(,,void,*,aligned_alloc,size_t alignment,size_t size)
__DPROTO(,,void,*,calloc,size_t nmemb,size_t size)
__DPROTO(`b,c',`b,c',void,,free,void *p)
__DPROTO(,,void,*,malloc,size_t size)
__DPROTO(,,void,*,realloc,void *p,size_t size)

__DPROTO(,,void,*,aligned_alloc_unlocked,size_t alignment,size_t size)
__DPROTO(,,void,*,calloc_unlocked,size_t nmemb,size_t size)
__DPROTO(`b,c',`b,c',void,,free_unlocked,void *p)
__DPROTO(,,void,*,malloc_unlocked,size_t size)
__DPROTO(,,void,*,realloc_unlocked,void *p,size_t size)

#endif

#endif
