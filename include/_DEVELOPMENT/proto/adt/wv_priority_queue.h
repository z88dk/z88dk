include(__link__.m4)

#ifndef _ADT_WV_PRIORITY_QUEUE_H
#define _ADT_WV_PRIORITY_QUEUE_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct wv_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_priority_queue_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wv_priority_queue_capacity,wv_priority_queue_t *q)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,wv_priority_queue_clear,wv_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,wv_priority_queue_data,wv_priority_queue_t *q)
__DPROTO(`b,c',`b,c',void,,wv_priority_queue_destroy,wv_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,wv_priority_queue_empty,wv_priority_queue_t *q)
__DPROTO(,,wv_priority_queue_t,*,wv_priority_queue_init,void *p,size_t capacity,size_t max_size,void *compar)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wv_priority_queue_max_size,wv_priority_queue_t *q)
__DPROTO(,,void,*,wv_priority_queue_pop,wv_priority_queue_t *q)
__DPROTO(,,int,,wv_priority_queue_push,wv_priority_queue_t *q,void *item)
__DPROTO(,,int,,wv_priority_queue_reserve,wv_priority_queue_t *q,size_t n)
__DPROTO(,,int,,wv_priority_queue_resize,wv_priority_queue_t *q,size_t n)
__DPROTO(,,int,,wv_priority_queue_shrink_to_fit,wv_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wv_priority_queue_size,wv_priority_queue_t *q)
__DPROTO(,,void,*,wv_priority_queue_top,wv_priority_queue_t *q)

#endif
