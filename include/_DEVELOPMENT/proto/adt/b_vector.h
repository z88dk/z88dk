include(__link__.m4)

#ifndef _ADT_B_VECTOR_H
#define _ADT_B_VECTOR_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct b_vector_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} b_vector_t;

__DPROTO(,,size_t,,b_vector_append,b_vector_t *v,int c)
__DPROTO(,,void,*,b_vector_append_block,b_vector_t *v,size_t n)
__DPROTO(,,size_t,,b_vector_append_n,b_vector_t *v,size_t n,int c)
__DPROTO(,,int,,b_vector_at,b_vector_t *v,size_t idx)
__DPROTO(,,int,,b_vector_back,b_vector_t *v)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,b_vector_capacity,b_vector_t *v)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,b_vector_clear,b_vector_t *v)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,b_vector_data,b_vector_t *v)
__DPROTO(`b,c',`b,c',void,,b_vector_destroy,b_vector_t *v)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,b_vector_empty,b_vector_t *v)
__DPROTO(,,size_t,,b_vector_erase,b_vector_t *v,size_t idx)
__DPROTO(,,size_t,,b_vector_erase_block,b_vector_t *v,size_t idx,size_t n)
__DPROTO(,,size_t,,b_vector_erase_range,b_vector_t *v,size_t idx_first,size_t idx_last)
__DPROTO(,,int,,b_vector_front,b_vector_t *v)
__DPROTO(,,b_vector_t,*,b_vector_init,void *p,size_t capacity,size_t max_size)
__DPROTO(,,size_t,,b_vector_insert,b_vector_t *v,size_t idx,int c)
__DPROTO(,,void,*,b_vector_insert_block,b_vector_t *v,size_t idx,size_t n)
__DPROTO(,,size_t,,b_vector_insert_n,b_vector_t *v,size_t idx,size_t n,int c)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,b_vector_max_size,b_vector_t *v)
__DPROTO(,,int,,b_vector_pop_back,b_vector_t *v)
__DPROTO(,,size_t,,b_vector_push_back,b_vector_t *v,int c)
__DPROTO(,,size_t,,b_vector_read_block,void *dst,size_t n,b_vector_t *v,size_t idx)
__DPROTO(,,int,,b_vector_reserve,b_vector_t *v,size_t n)
__DPROTO(,,int,,b_vector_resize,b_vector_t *v,size_t n)
__DPROTO(,,int,,b_vector_shrink_to_fit,b_vector_t *)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,b_vector_size,b_vector_t *v)
__DPROTO(,,size_t,,b_vector_write_block,void *src,size_t n,b_vector_t *v,size_t idx)

#endif
