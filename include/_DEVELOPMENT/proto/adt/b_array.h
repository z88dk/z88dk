include(__link__.m4)

#ifndef _ADT_B_ARRAY_H
#define _ADT_B_ARRAY_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct b_array_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} b_array_t;

__DPROTO(,,size_t,,b_array_append,b_array_t *a,int c)
__DPROTO(,,void,*,b_array_append_block,b_array_t *a,size_t n)
__DPROTO(,,size_t,,b_array_append_n,b_array_t *a,size_t n,int c)
__DPROTO(,,int,,b_array_at,b_array_t *a,size_t idx)
__DPROTO(,,int,,b_array_back,b_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,b_array_capacity,b_array_t *a)
__DPROTO(`a,b,c,d,e',`b,c,d,e',void,,b_array_clear,b_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,b_array_data,b_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',void,,b_array_destroy,b_array_t *a)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,b_array_empty,b_array_t *a)
__DPROTO(,,size_t,,b_array_erase,b_array_t *a,size_t idx)
__DPROTO(,,size_t,,b_array_erase_block,b_array_t *a,size_t idx,size_t n)
__DPROTO(,,size_t,,b_array_erase_range,b_array_t *a,size_t idx_first,size_t idx_last)
__DPROTO(,,int,,b_array_front,b_array_t *a)
__DPROTO(,,b_array_t,*,b_array_init,void *p,void *data,size_t capacity)
__DPROTO(,,size_t,,b_array_insert,b_array_t *a,size_t idx,int c)
__DPROTO(,,void,*,b_array_insert_block,b_array_t *a,size_t idx,size_t n)
__DPROTO(,,size_t,,b_array_insert_n,b_array_t *a,size_t idx,size_t n,int c)
__DPROTO(,,int,,b_array_pop_back,b_array_t *a)
__DPROTO(,,size_t,,b_array_push_back,b_array_t *a,int c)
__DPROTO(,,size_t,,b_array_read_block,void *dst,size_t n,b_array_t *a,size_t idx)
__DPROTO(,,int,,b_array_resize,b_array_t *a,size_t n)
__DPROTO(`b,c,d,e',`b,c,d,e',size_t,,b_array_size,b_array_t *a)
__DPROTO(,,size_t,,b_array_write_block,void *src,size_t n,b_array_t *a,size_t idx)

#endif
