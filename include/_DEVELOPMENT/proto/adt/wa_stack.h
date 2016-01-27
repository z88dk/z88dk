include(__link__.m4)

#ifndef _ADT_WA_STACK_H
#define _ADT_WA_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct wa_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} wa_stack_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wa_stack_capacity,wa_stack_t *s)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,wa_stack_clear,wa_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',void,,wa_stack_destroy,wa_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,wa_stack_empty,wa_stack_t *s)
__DPROTO(,,wa_stack_t,*,wa_stack_init,void *p,void *data,size_t capacity)
__DPROTO(,,void,*,wa_stack_pop,wa_stack_t *s)
__DPROTO(,,int,,wa_stack_push,wa_stack_t *s,void *item)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wa_stack_size,wa_stack_t *s)
__DPROTO(,,void,*,wa_stack_top,wa_stack_t *s)

#endif
