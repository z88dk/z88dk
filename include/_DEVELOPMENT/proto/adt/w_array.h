include(__link__.m4)

#ifndef _ADT_W_ARRAY_H
#define _ADT_W_ARRAY_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct w_array_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} w_array_t;

__DPROTO(,,size_t,,w_array_append,w_array_t *a,void *item)
__DPROTO(,,size_t,,w_array_append_n,w_array_t *a,size_t n,void *item)
__DPROTO(,,void,*,w_array_at,w_array_t *a,size_t idx)
__DPROTO(,,void,*,w_array_back,w_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,w_array_capacity,w_array_t *a)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,w_array_clear,w_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,w_array_data,w_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',void,,w_array_destroy,w_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,w_array_empty,w_array_t *a)
__DPROTO(,,size_t,,w_array_erase,w_array_t *a,size_t idx)
__DPROTO(,,size_t,,w_array_erase_range,w_array_t *a,size_t idx_first,size_t idx_last)
__DPROTO(,,void,*,w_array_front,w_array_t *a)
__DPROTO(,,w_array_t,*,w_array_init,void *p,void *data,size_t capacity)
__DPROTO(,,size_t,,w_array_insert,w_array_t *a,size_t idx,void *item)
__DPROTO(,,size_t,,w_array_insert_n,w_array_t *a,size_t idx,size_t n,void *item)
__DPROTO(,,void,*,w_array_pop_back,w_array_t *a)
__DPROTO(,,size_t,,w_array_push_back,w_array_t *a,void *item)
__DPROTO(,,int,,w_array_resize,w_array_t *a,size_t n)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,w_array_size,w_array_t *a)

#endif
