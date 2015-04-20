
#ifndef _ADT_BV_STACK_H
#define _ADT_BV_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct bv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} bv_stack_t;

#ifdef __SDCC

// SDCC

extern size_t      bv_stack_capacity(bv_stack_t *s);
extern void        bv_stack_clear(bv_stack_t *s);
extern void        bv_stack_destroy(bv_stack_t *s);
extern int         bv_stack_empty(bv_stack_t *s);
extern bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size);
extern size_t      bv_stack_max_size(bv_stack_t *s);
extern int         bv_stack_pop(bv_stack_t *s);
extern int         bv_stack_push(bv_stack_t *s, int c);
extern int         bv_stack_reserve(bv_stack_t *s, size_t n);
extern int         bv_stack_shrink_to_fit(bv_stack_t *s);
extern size_t      bv_stack_size(bv_stack_t *s);
extern int         bv_stack_top(bv_stack_t *s);

#ifndef __SDCC_DISABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern size_t      bv_stack_capacity_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern void        bv_stack_clear_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern void        bv_stack_destroy_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern int         bv_stack_empty_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern size_t      bv_stack_max_size_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern int         bv_stack_pop_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern int         bv_stack_shrink_to_fit_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern size_t      bv_stack_size_fastcall(bv_stack_t *s) __z88dk_fastcall;
extern int         bv_stack_top_fastcall(bv_stack_t *s) __z88dk_fastcall;

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define bv_stack_capacity(a)            bv_stack_capacity_fastcall(a)
#define bv_stack_clear(a)               bv_stack_clear_fastcall(a)
#define bv_stack_destroy(a)             bv_stack_destroy_fastcall(a)
#define bv_stack_empty(a)               bv_stack_empty_fastcall(a)
#define bv_stack_max_size(a)            bv_stack_max_size_fastcall(a)
#define bv_stack_pop(a)                 bv_stack_pop_fastcall(a)
#define bv_stack_shrink_to_fit(a)       bv_stack_shrink_to_fit_fastcall(a)
#define bv_stack_size(a)                bv_stack_size_fastcall(a)
#define bv_stack_top(a)                 bv_stack_top_fastcall(a)

#endif

#else

// SCCZ80

extern size_t     __LIB__ __FASTCALL__  bv_stack_capacity(bv_stack_t *s);
extern void       __LIB__ __FASTCALL__  bv_stack_clear(bv_stack_t *s);
extern void       __LIB__ __FASTCALL__  bv_stack_destroy(bv_stack_t *s);
extern int        __LIB__ __FASTCALL__  bv_stack_empty(bv_stack_t *s);
extern bv_stack_t __LIB__              *bv_stack_init(void *p, size_t capacity, size_t max_size);
extern size_t     __LIB__ __FASTCALL__  bv_stack_max_size(bv_stack_t *s);
extern int        __LIB__ __FASTCALL__  bv_stack_pop(bv_stack_t *s);
extern int        __LIB__               bv_stack_push(bv_stack_t *s, int c);
extern int        __LIB__               bv_stack_reserve(bv_stack_t *s, size_t n);
extern int        __LIB__ __FASTCALL__  bv_stack_shrink_to_fit(bv_stack_t *s);
extern size_t     __LIB__ __FASTCALL__  bv_stack_size(bv_stack_t *s);
extern int        __LIB__ __FASTCALL__  bv_stack_top(bv_stack_t *s);

// SCCZ80 CALLEE LINKAGE

extern bv_stack_t __LIB__ __CALLEE__   *bv_stack_init_callee(void *p, size_t capacity, size_t max_size);
extern int        __LIB__ __CALLEE__    bv_stack_push_callee(bv_stack_t *s, int c);
extern int        __LIB__ __CALLEE__    bv_stack_reserve_callee(bv_stack_t *s, size_t n);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define bv_stack_init(a,b,c)                     bv_stack_init_callee(a,b,c)
#define bv_stack_push(a,b)                       bv_stack_push_callee(a,b)
#define bv_stack_reserve(a,b)                    bv_stack_reserve_callee(a,b)

#endif

#endif
