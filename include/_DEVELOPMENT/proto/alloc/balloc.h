include(__link__.m4)

#ifndef _ALLOC_BALLOC_H
#define _ALLOC_BALLOC_H

#include <stddef.h>

__DPROTO(,,void,*,balloc_addmem,int q,size_t num,size_t size,void *p)
__DPROTO(`b,c',`b,c',void,*,balloc_alloc,int q)
__DPROTO(`b,c',`b,c',size_t,,balloc_blockcount,int q)
__DPROTO(,,void,*,balloc_firstfit,int q,int numq)
__DPROTO(,,void,,balloc_free,void *p)

#endif
