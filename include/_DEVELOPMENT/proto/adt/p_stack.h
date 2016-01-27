include(__link__.m4)

#ifndef _ADT_P_STACK_H
#define _ADT_P_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef void* p_stack_t;

__DPROTO(`b,c',`b,c',void,,p_stack_clear,p_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,p_stack_empty,p_stack_t *s)
__DPROTO(`b,c',`b,c',void,,p_stack_init,void *p)
__DPROTO(`b,c',`b,c',void,*,p_stack_pop,p_stack_t *s)
__DPROTO(`b,c',`b,c',void,,p_stack_push,p_stack_t *s,void *item)
__DPROTO(`b,c',`b,c',size_t,,p_stack_size,p_stack_t *s)
__DPROTO(`b,c,d,e',`b,c,d,e',void,*,p_stack_top,p_stack_t *s)

#endif
