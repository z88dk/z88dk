include(__link__.m4)

#ifndef _ADT_WV_STACK_H
#define _ADT_WV_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct wv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_stack_t;

__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wv_stack_capacity,wv_stack_t *s)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,wv_stack_clear,wv_stack_t *s)
__DPROTO(`b,c',`b,c',void,,wv_stack_destroy,wv_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,wv_stack_empty,wv_stack_t *s)
__DPROTO(,,wv_stack_t,*,wv_stack_init,void *p,size_t capacity,size_t max_size)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wv_stack_max_size,wv_stack_t *s)
__DPROTO(,,void,*,wv_stack_pop,wv_stack_t *s)
__DPROTO(,,int,,wv_stack_push,wv_stack_t *s,void *item)
__DPROTO(,,int,,wv_stack_reserve,wv_stack_t *s,size_t n)
__DPROTO(,,int,,wv_stack_shrink_to_fit,wv_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,wv_stack_size,wv_stack_t *s)
__DPROTO(,,void,*,wv_stack_top,wv_stack_t *s)

#endif
