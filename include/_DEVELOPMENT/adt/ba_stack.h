
#ifndef _ADT_BA_STACK_H
#define _ADT_BA_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct ba_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} ba_stack_t;

#ifdef __SDCC

// SDCC

extern size_t      ba_stack_capacity(ba_stack_t *s);
extern void        ba_stack_clear(ba_stack_t *s);
extern void        ba_stack_destroy(ba_stack_t *s);
extern int         ba_stack_empty(ba_stack_t *s);
extern ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity);
extern int         ba_stack_pop(ba_stack_t *s);
extern int         ba_stack_push(ba_stack_t *s, int c);
extern size_t      ba_stack_size(ba_stack_t *s);
extern int         ba_stack_top(ba_stack_t *s);

#ifndef __SDCC_DISABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern size_t      ba_stack_capacity_fastcall(ba_stack_t *s) __z88dk_fastcall;
extern void        ba_stack_clear_fastcall(ba_stack_t *s) __z88dk_fastcall;
extern void        ba_stack_destroy_fastcall(ba_stack_t *s) __z88dk_fastcall;
extern int         ba_stack_empty_fastcall(ba_stack_t *s) __z88dk_fastcall;
extern int         ba_stack_pop_fastcall(ba_stack_t *s) __z88dk_fastcall;
extern size_t      ba_stack_size_fastcall(ba_stack_t *s) __z88dk_fastcall;
extern int         ba_stack_top_fastcall(ba_stack_t *s) __z88dk_fastcall;

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define ba_stack_capacity(a)            ba_stack_capacity_fastcall(a)
#define ba_stack_clear(a)               ba_stack_clear_fastcall(a)
#define ba_stack_destroy(a)             ba_stack_destroy_fastcall(a)
#define ba_stack_empty(a)               ba_stack_empty_fastcall(a)
#define ba_stack_pop(a)                 ba_stack_pop_fastcall(a)
#define ba_stack_size(a)                ba_stack_size_fastcall(a)
#define ba_stack_top(a)                 ba_stack_top_fastcall(a)

#endif

#else

// SCCZ80

extern size_t     __LIB__ __FASTCALL__  ba_stack_capacity(ba_stack_t *s);
extern void       __LIB__ __FASTCALL__  ba_stack_clear(ba_stack_t *s);
extern void       __LIB__ __FASTCALL__  ba_stack_destroy(ba_stack_t *s);
extern int        __LIB__ __FASTCALL__  ba_stack_empty(ba_stack_t *s);
extern ba_stack_t __LIB__              *ba_stack_init(void *p, void *data, size_t capacity);
extern int        __LIB__ __FASTCALL__  ba_stack_pop(ba_stack_t *s);
extern int        __LIB__               ba_stack_push(ba_stack_t *s, int c);
extern size_t     __LIB__ __FASTCALL__  ba_stack_size(ba_stack_t *s);
extern int        __LIB__ __FASTCALL__  ba_stack_top(ba_stack_t *s);

// SCCZ80 CALLEE LINKAGE

extern ba_stack_t __LIB__ __CALLEE__   *ba_stack_init_callee(void *p, void *data, size_t capacity);
extern int        __LIB__ __CALLEE__    ba_stack_push_callee(ba_stack_t *s, int c);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define ba_stack_init(a,b,c)                     ba_stack_init_callee(a,b,c)
#define ba_stack_push(a,b)                       ba_stack_push_callee(a,b)

#endif

#endif
