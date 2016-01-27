include(__link__.m4)

#ifndef _ADT_P_LIST_H
#define _ADT_P_LIST_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct p_list_s
{

   void       *head;
   void       *tail;

} p_list_t;

__DPROTO(`b,c,d,e',`b,c,d,e',void,*,p_list_back,p_list_t *ls)
__DPROTO(`b,c',`b,c',void,,p_list_clear,p_list_t *ls)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,p_list_empty,p_list_t *ls)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,p_list_front,p_list_t *ls)
__DPROTO(`b,c',`b,c',void,,p_list_init,void *p)
__DPROTO(,,void,*,p_list_insert,p_list_t *ls,void *ls_item,void *item)
__DPROTO(,,void,*,p_list_insert_after,p_list_t *ls,void *ls_item,void *item)
__DPROTO(`b,c',`b,c',void,*,p_list_next,void *item)
__DPROTO(,,void,*,p_list_pop_back,p_list_t *ls)
__DPROTO(,,void,*,p_list_pop_front,p_list_t *ls)
__DPROTO(`b,c',`b,c',void,*,p_list_prev,void *item)
__DPROTO(,,void,*,p_list_push_back,p_list_t *ls,void *item)
__DPROTO(,,void,*,p_list_push_front,p_list_t *ls,void *item)
__DPROTO(,,void,*,p_list_remove,p_list_t *ls,void *item)
__DPROTO(,,void,*,p_list_remove_after,p_list_t *ls,void *ls_item)
__DPROTO(`b,c',`b,c',size_t,,p_list_size,p_list_t *ls)

#endif
