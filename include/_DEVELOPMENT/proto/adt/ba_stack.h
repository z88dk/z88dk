include(__link__.m4)

#ifndef _ADT_BA_STACK_H
#define _ADT_BA_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct ba_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} ba_stack_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,ba_stack_capacity,ba_stack_t *s)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,ba_stack_clear,ba_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',void,,ba_stack_destroy,ba_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,ba_stack_empty,ba_stack_t *s)
__DPROTO(,,ba_stack_t,*,ba_stack_init,void *p,void *data,size_t capacity)
__DPROTO(,,int,,ba_stack_pop,ba_stack_t *s)
__DPROTO(,,int,,ba_stack_push,ba_stack_t *s,int c)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,ba_stack_size,ba_stack_t *s)
__DPROTO(,,int,,ba_stack_top,ba_stack_t *s)

#endif
