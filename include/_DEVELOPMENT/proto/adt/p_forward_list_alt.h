include(__link__.m4)

#ifndef _ADT_P_FORWARD_LIST_ALT
#define _ADT_P_FORWARD_LIST_ALT

#include <stddef.h>

// DATA STRUCTURES

typedef struct p_forward_list_alt_s
{

   void       *head;
   void       *tail;

} p_forward_list_alt_t;

__DPROTO(`b,c,d,e',`b,c,d,e',void,*,p_forward_list_alt_back,p_forward_list_alt_t *ls)
__DPROTO(`b,c',`b,c',void,,p_forward_list_alt_clear,p_forward_list_alt_t *ls)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,p_forward_list_alt_empty,p_forward_list_alt_t *ls)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,p_forward_list_alt_front,p_forward_list_alt_t *ls)
__DPROTO(`b,c',`b,c',void,,p_forward_list_alt_init,void *p)
__DPROTO(,,void,*,p_forward_list_alt_insert_after,p_forward_list_alt_t *ls,void *ls_item,void *item)
__DPROTO(`b,c',`b,c',void,*,p_forward_list_alt_next,void *item)
__DPROTO(,,void,*,p_forward_list_alt_pop_back,p_forward_list_alt_t *ls)
__DPROTO(,,void,*,p_forward_list_alt_pop_front,p_forward_list_alt_t *ls)
__DPROTO(,,void,*,p_forward_list_alt_prev,p_forward_list_alt_t *ls,void *next)
__DPROTO(,,void,,p_forward_list_alt_push_back,p_forward_list_alt_t *ls,void *item)
__DPROTO(,,void,,p_forward_list_alt_push_front,p_forward_list_alt_t *ls,void *item)
__DPROTO(,,void,*,p_forward_list_alt_remove,p_forward_list_alt_t *ls,void *item)
__DPROTO(,,void,*,p_forward_list_alt_remove_after,p_forward_list_alt_t *ls,void *ls_item)
__DPROTO(`b,c',`b,c',size_t,,p_forward_list_alt_size,p_forward_list_alt_t *ls)

#endif
