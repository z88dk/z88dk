include(__link__.m4)

#ifndef _ADT_BV_STACK_H
#define _ADT_BV_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct bv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} bv_stack_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,bv_stack_capacity,bv_stack_t *s)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,bv_stack_clear,bv_stack_t *s)
__DPROTO(`b,c',`b,c',void,,bv_stack_destroy,bv_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,bv_stack_empty,bv_stack_t *s)
__DPROTO(,,bv_stack_t,*,bv_stack_init,void *p,size_t capacity,size_t max_size)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,bv_stack_max_size,bv_stack_t *s)
__DPROTO(,,int,,bv_stack_pop,bv_stack_t *s)
__DPROTO(,,int,,bv_stack_push,bv_stack_t *s,int c)
__DPROTO(,,int,,bv_stack_reserve,bv_stack_t *s,size_t n)
__DPROTO(,,int,,bv_stack_shrink_to_fit,bv_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,bv_stack_size,bv_stack_t *s)
__DPROTO(,,int,,bv_stack_top,bv_stack_t *s)

#endif
