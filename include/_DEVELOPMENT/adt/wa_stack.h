
#ifndef _ADT_WA_STACK_H
#define _ADT_WA_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct wa_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} wa_stack_t;

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern size_t      wa_stack_capacity(wa_stack_t *s);
extern void        wa_stack_clear(wa_stack_t *s);
extern void        wa_stack_destroy(wa_stack_t *s);
extern int         wa_stack_empty(wa_stack_t *s);
extern wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity);
extern void       *wa_stack_pop(wa_stack_t *s);
extern int         wa_stack_push(wa_stack_t *s, void *item);
extern size_t      wa_stack_size(wa_stack_t *s);
extern void       *wa_stack_top(wa_stack_t *s);

#else

// SCCZ80

extern size_t     __LIB__ __FASTCALL__  wa_stack_capacity(wa_stack_t *s);
extern void       __LIB__ __FASTCALL__  wa_stack_clear(wa_stack_t *s);
extern void       __LIB__ __FASTCALL__  wa_stack_destroy(wa_stack_t *s);
extern int        __LIB__ __FASTCALL__  wa_stack_empty(wa_stack_t *s);
extern wa_stack_t __LIB__              *wa_stack_init(void *p, void *data, size_t capacity);
extern void       __LIB__ __FASTCALL__ *wa_stack_pop(wa_stack_t *s);
extern int        __LIB__               wa_stack_push(wa_stack_t *s, void *item);
extern size_t     __LIB__ __FASTCALL__  wa_stack_size(wa_stack_t *s);
extern void       __LIB__ __FASTCALL__ *wa_stack_top(wa_stack_t *s);

// SCCZ80 CALLEE LINKAGE

extern wa_stack_t __LIB__ __CALLEE__   *wa_stack_init_callee(void *p, void *data, size_t capacity);
extern int        __LIB__ __CALLEE__    wa_stack_push_callee(wa_stack_t *s, void *item);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define wa_stack_init(a,b,c)                     wa_stack_init_callee(a,b,c)
#define wa_stack_push(a,b)                       wa_stack_push_callee(a,b)

#endif

#endif
