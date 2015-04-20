
#ifndef _ADT_P_STACK_H
#define _ADT_P_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef void* p_stack_t;

#ifdef __SDCC

// SDCC

extern void        p_stack_clear(p_stack_t *s);
extern int         p_stack_empty(p_stack_t *s);
extern void        p_stack_init(void *p);
extern void       *p_stack_pop(p_stack_t *s);
extern void        p_stack_push(p_stack_t *s, void *item);
extern size_t      p_stack_size(p_stack_t *s);
extern void       *p_stack_top(p_stack_t *s);

#ifndef __SDCC_DISABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern void        p_stack_clear_fastcall(p_stack_t *s) __z88dk_fastcall;
extern int         p_stack_empty_fastcall(p_stack_t *s) __z88dk_fastcall;
extern void        p_stack_init_fastcall(void *p) __z88dk_fastcall;
extern void       *p_stack_pop_fastcall(p_stack_t *s) __z88dk_fastcall;
extern size_t      p_stack_size_fastcall(p_stack_t *s) __z88dk_fastcall;
extern void       *p_stack_top_fastcall(p_stack_t *s) __z88dk_fastcall;

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define p_stack_clear(a)                p_stack_clear_fastcall(a)
#define p_stack_empty(a)                p_stack_empty_fastcall(a)
#define p_stack_init(a)                 p_stack_init_fastcall(a)
#define p_stack_pop(a)                  p_stack_pop_fastcall(a)
#define p_stack_size(a)                 p_stack_size_fastcall(a)
#define p_stack_top(a)                  p_stack_top_fastcall(a)

#endif

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
