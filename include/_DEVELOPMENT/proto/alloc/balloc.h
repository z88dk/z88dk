include(__link__.m4)

#ifndef __ALLOC_BALLOC_H__
#define __ALLOC_BALLOC_H__

#include <stddef.h>

__DPROTO(,,void,*,balloc_addmem,unsigned char q,size_t num,size_t size,void *p)
__DPROTO(`b,c',`b,c',void,*,balloc_alloc,unsigned char q)
__DPROTO(`b,c',`b,c',size_t,,balloc_blockcount,unsigned char q)
__DPROTO(,,void,*,balloc_firstfit,unsigned char q,unsigned char numq)
__DPROTO(,,void,,balloc_free,void *p)
__DPROTO(`b,c',`b,c',void,*,balloc_reset,unsigned char q)

#endif
