include(__link__.m4)

#ifndef _ADT_BV_PRIORITY_QUEUE_H
#define _ADT_BV_PRIORITY_QUEUE_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct bv_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} bv_priority_queue_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,bv_priority_queue_capacity,bv_priority_queue_t *q)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,bv_priority_queue_clear,bv_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,bv_priority_queue_data,bv_priority_queue_t *q)
__DPROTO(`b,c',`b,c',void,,bv_priority_queue_destroy,bv_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,bv_priority_queue_empty,bv_priority_queue_t *q)
__DPROTO(,,bv_priority_queue_t,*,bv_priority_queue_init,void *p,size_t capacity,size_t max_size,void *compar)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,bv_priority_queue_max_size,bv_priority_queue_t *q)
__DPROTO(,,int,,bv_priority_queue_pop,bv_priority_queue_t *q)
__DPROTO(,,int,,bv_priority_queue_push,bv_priority_queue_t *q,int c)
__DPROTO(,,int,,bv_priority_queue_reserve,bv_priority_queue_t *q,size_t n)
__DPROTO(,,int,,bv_priority_queue_resize,bv_priority_queue_t *q,size_t n)
__DPROTO(,,int,,bv_priority_queue_shrink_to_fit,bv_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,bv_priority_queue_size,bv_priority_queue_t *q)
__DPROTO(,,int,,bv_priority_queue_top,bv_priority_queue_t *q)

#endif
