include(__link__.m4)

#ifndef _ALLOC_OBSTACK_H
#define _ALLOC_OBSTACK_H

#include <stddef.h>

// DATA STRUCTURES

struct obstack
{
   void       *fence;
   void       *object;
   void       *end;
};

__DPROTO(,,void,*,obstack_1grow,struct obstack *ob,int c)
__DPROTO(`b,c',`b,c',void,*,obstack_1grow_fast,struct obstack *ob,int c)
__DPROTO(,,size_t,,obstack_align_distance,struct obstack *ob,size_t alignment)
__DPROTO(,,int,,obstack_align_to,struct obstack *ob,size_t alignment)
__DPROTO(,,void,*,obstack_alloc,struct obstack *ob,size_t size)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,obstack_base,struct obstack *ob)
__DPROTO(,,void,*,obstack_blank,struct obstack *ob,int size)
__DPROTO(,,void,*,obstack_blank_fast,struct obstack *ob,int size)
__DPROTO(,,void,*,obstack_copy,struct obstack *ob,void *p,size_t size)
__DPROTO(,,void,*,obstack_copy0,struct obstack *ob,void *p,size_t size)
__DPROTO(`a',,void,*,obstack_finish,struct obstack *ob)
__DPROTO(,,void,*,obstack_free,struct obstack *ob,void *object)
__DPROTO(,,int,,obstack_grow,struct obstack *ob,void *data,size_t size)
__DPROTO(,,int,,obstack_grow0,struct obstack *ob,void *data,size_t size)
__DPROTO(,,void,*,obstack_init,struct obstack *ob,size_t size)
__DPROTO(,,void,*,obstack_int_grow,struct obstack *ob,int data)
__DPROTO(,,void,*,obstack_int_grow_fast,struct obstack *ob,int data)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,obstack_next_free,struct obstack *ob)
__DPROTO(`b,c',`b,c',size_t,,obstack_object_size,struct obstack *ob)
__DPROTO(`b,c',`b,c',size_t,,obstack_room,struct obstack *ob)

#endif
