include(__link__.m4)

#ifndef _ADT_P_FORWARD_LIST_H
#define _ADT_P_FORWARD_LIST_H

#include <stddef.h>

// DATA STRUCTURES

typedef void* p_forward_list_t;

__DPROTO(,,void,*,p_forward_list_back,p_forward_list_t *ls)
__DPROTO(`a,b,c,d,e,h,l',`b,c,d,e,h,l',void,,p_forward_list_clear,p_forward_list_t *ls)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,p_forward_list_empty,p_forward_list_t *ls)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,p_forward_list_front,p_forward_list_t *ls)
__DPROTO(`b,c',`b,c',void,,p_forward_list_init,void *p)
__DPROTO(`b,c',`b,c',void,*,p_forward_list_insert_after,void *ls_item,void *item)
__DPROTO(`b,c',`b,c',void,*,p_forward_list_next,void *item)
__DPROTO(,,void,*,p_forward_list_pop_back,p_forward_list_t *ls)
__DPROTO(`b,c',`b,c',void,*,p_forward_list_pop_front,p_forward_list_t *ls)
__DPROTO(,,void,*,p_forward_list_prev,p_forward_list_t *ls,void *item)
__DPROTO(,,void,,p_forward_list_push_back,p_forward_list_t *ls,void *item)
__DPROTO(`b,c',`b,c',void,,p_forward_list_push_front,p_forward_list_t *ls,void *item)
__DPROTO(,,void,*,p_forward_list_remove,p_forward_list_t *ls,void *item)
__DPROTO(`b,c',`b,c',void,*,p_forward_list_remove_after,void *ls_item)
__DPROTO(`b,c',`b,c',size_t,,p_forward_list_size,p_forward_list_t *ls)

#endif
