include(__link__.m4)

#ifndef _ADT_W_VECTOR_H
#define _ADT_W_VECTOR_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct w_vector_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} w_vector_t;

__DPROTO(,,size_t,,w_vector_append,w_vector_t *v,void *item)
__DPROTO(,,size_t,,w_vector_append_n,w_vector_t *v,size_t n,void *item)
__DPROTO(,,void,,w_vector_at,w_vector_t *v,size_t idx)
__DPROTO(,,void,*,w_vector_back,w_vector_t *v)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,w_vector_capacity,w_vector_t *v)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,w_vector_clear,w_vector_t *v)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,w_vector_data,w_vector_t *v)
__DPROTO(`b,c',`b,c',void,,w_vector_destroy,w_vector_t *v)
__DPROTO(`b,c,d,e',`b,c,d,e',void,,w_vector_empty,w_vector_t *v)
__DPROTO(,,size_t,,w_vector_erase,w_vector_t *v,size_t idx)
__DPROTO(,,size_t,,w_vector_erase_range,w_vector_t *v,size_t idx_first,size_t idx_last)
__DPROTO(,,void,*,w_vector_front,w_vector_t *v)
__DPROTO(,,w_vector_t,*,w_vector_init,void *p,size_t capacity,size_t max_size)
__DPROTO(,,size_t,,w_vector_insert,w_vector_t *v,size_t idx,void *item)
__DPROTO(,,size_t,,w_vector_insert_n,w_vector_t *v,size_t idx,size_t n,void *item)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,w_vector_max_size,w_vector_t *v)
__DPROTO(,,void,*,w_vector_pop_back,w_vector_t *v)
__DPROTO(,,size_t,,w_vector_push_back,w_vector_t *v,void *item)
__DPROTO(,,int,,w_vector_reserve,w_vector_t *v,size_t n)
__DPROTO(,,int,,w_vector_resize,w_vector_t *v,size_t n)
__DPROTO(,,int,,w_vector_shrink_to_fit,w_vector_t *v)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,w_vector_size,w_vector_t *v)

#endif
