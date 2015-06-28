include(__link__.m4)

#ifndef _ADT_P_QUEUE_H
#define _ADT_P_QUEUE_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct p_queue_s
{
   void       *head;
   void       *tail;

} p_queue_t;

__DPROTO(void,*,p_queue_back,p_queue_t *q)
__DPROTO(void,,p_queue_clear,p_queue_t *q)
__DPROTO(int,,p_queue_empty,p_queue_t *q)
__DPROTO(void,*,p_queue_front,p_queue_t *q)
__DPROTO(void,,p_queue_init,void *p)
__DPROTO(void,*,p_queue_pop,p_queue_t *q)
__DPROTO(void,,p_queue_push,p_queue_t *q,void *item)
__DPROTO(size_t,,p_queue_size,p_queue_t *q)

#endif
