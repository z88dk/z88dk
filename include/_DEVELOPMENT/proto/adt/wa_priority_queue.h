include(__link__.m4)

#ifndef _ADT_WA_PRIORITY_QUEUE_H
#define _ADT_WA_PRIORITY_QUEUE_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct wa_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;

} wa_priority_queue_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wa_priority_queue_capacity,wa_priority_queue_t *q)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,wa_priority_queue_clear,wa_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,wa_priority_queue_data,wa_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',void,,wa_priority_queue_destroy,wa_priority_queue_t *q)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,wa_priority_queue_empty,wa_priority_queue_t *q)
__DPROTO(,,wa_priority_queue_t,*,wa_priority_queue_init,void *p,void *data,size_t capacity,void *compar)
__DPROTO(,,void,*,wa_priority_queue_pop,wa_priority_queue_t *q)
__DPROTO(,,int,,wa_priority_queue_push,wa_priority_queue_t *q,void *item)
__DPROTO(,,int,,wa_priority_queue_resize,wa_priority_queue_t *q,size_t n)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wa_priority_queue_size,wa_priority_queue_t *q)
__DPROTO(,,void,*,wa_priority_queue_top,wa_priority_queue_t *q)

#endif
