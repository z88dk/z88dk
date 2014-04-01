
#ifndef _ADT_P_STACK_H
#define _ADT_P_STACK_H

#include <_DEVELOPMENT/stddef.h>

// DATA STRUCTURES

typedef void* p_stack_t;

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern void        p_stack_clear(p_stack_t *s);
extern int         p_stack_empty(p_stack_t *s);
extern void        p_stack_init(void *p);
extern void       *p_stack_pop(p_stack_t *s);
extern void        p_stack_push(p_stack_t *s, void *item);
extern size_t      p_stack_size(p_stack_t *s);
extern void       *p_stack_top(p_stack_t *s);

#else

// SCCZ80

extern void       __LIB__ __FASTCALL__  p_stack_clear(p_stack_t *s);
extern int        __LIB__ __FASTCALL__  p_stack_empty(p_stack_t *s);
extern void       __LIB__ __FASTCALL__  p_stack_init(void *p);
extern void       __LIB__ __FASTCALL__ *p_stack_pop(p_stack_t *s);
extern void       __LIB__               p_stack_push(p_stack_t *s, void *item);
extern size_t     __LIB__ __FASTCALL__  p_stack_size(p_stack_t *s);
extern void       __LIB__ __FASTCALL__ *p_stack_top(p_stack_t *s);

// SCCZ80 CALLEE LINKAGE

extern void       __LIB__ __CALLEE__    p_stack_push_callee(p_stack_t *s, void *item);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define p_stack_push(a,b)                        p_stack_push_callee(a,b)

#endif

#endif
