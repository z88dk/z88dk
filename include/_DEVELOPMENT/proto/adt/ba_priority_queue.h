include(__link__.m4)

#ifndef _ADT_BA_PRIORITY_QUEUE_H
#define _ADT_BA_PRIORITY_QUEUE_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct ba_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;

} ba_priority_queue_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,ba_priority_queue_capacity,ba_priority_queue_t *q)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,ba_priority_queue_clear,ba_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,ba_priority_queue_data,ba_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',void,,ba_priority_queue_destroy,ba_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,ba_priority_queue_empty,ba_priority_queue_t *q)
__DPROTO(,,ba_priority_queue_t,*,ba_priority_queue_init,void *p,void *data,size_t capacity,void *compar)
__DPROTO(,,int,,ba_priority_queue_pop,ba_priority_queue_t *q)
__DPROTO(,,int,,ba_priority_queue_push,ba_priority_queue_t *q,int c)
__DPROTO(,,int,,ba_priority_queue_resize,ba_priority_queue_t *q,size_t n)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,ba_priority_queue_size,ba_priority_queue_t *q)
__DPROTO(,,int,,ba_priority_queue_top,ba_priority_queue_t *q)

#endif
