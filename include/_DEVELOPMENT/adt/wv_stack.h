
#ifndef _ADT_WV_STACK_H
#define _ADT_WV_STACK_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct wv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_stack_t;

#ifdef __SDCC

// SDCC

extern size_t      wv_stack_capacity(wv_stack_t *s);
extern void        wv_stack_clear(wv_stack_t *s);
extern void        wv_stack_destroy(wv_stack_t *s);
extern int         wv_stack_empty(wv_stack_t *s);
extern wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size);
extern size_t      wv_stack_max_size(wv_stack_t *s);
extern void       *wv_stack_pop(wv_stack_t *s);
extern int         wv_stack_push(wv_stack_t *s, void *item);
extern int         wv_stack_reserve(wv_stack_t *s, size_t n);
extern int         wv_stack_shrink_to_fit(wv_stack_t *s);
extern size_t      wv_stack_size(wv_stack_t *s);
extern void       *wv_stack_top(wv_stack_t *s);

#ifndef __SDCC_DISABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern size_t      wv_stack_capacity_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern void        wv_stack_clear_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern void        wv_stack_destroy_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern int         wv_stack_empty_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern size_t      wv_stack_max_size_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern void       *wv_stack_pop_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern int         wv_stack_shrink_to_fit_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern size_t      wv_stack_size_fastcall(wv_stack_t *s) __z88dk_fastcall;
extern void       *wv_stack_top_fastcall(wv_stack_t *s) __z88dk_fastcall;

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define wv_stack_capacity(a)            wv_stack_capacity_fastcall(a)
#define wv_stack_clear(a)               wv_stack_clear_fastcall(a)
#define wv_stack_destroy(a)             wv_stack_destroy_fastcall(a)
#define wv_stack_empty(a)               wv_stack_empty_fastcall(a)
#define wv_stack_max_size(a)            wv_stack_max_size_fastcall(a)
#define wv_stack_pop(a)                 wv_stack_pop_fastcall(a)
#define wv_stack_shrink_to_fit(a)       wv_stack_shrink_to_fit_fastcall(a)
#define wv_stack_size(a)                wv_stack_stack_fastcall(a)
#define wv_stack_top(a)                 wv_stack_top_fastcall(a)

#endif

#else

// SCCZ80

extern size_t     __LIB__ __FASTCALL__  wv_stack_capacity(wv_stack_t *s);
extern void       __LIB__ __FASTCALL__  wv_stack_clear(wv_stack_t *s);
extern void       __LIB__ __FASTCALL__  wv_stack_destroy(wv_stack_t *s);
extern int        __LIB__ __FASTCALL__  wv_stack_empty(wv_stack_t *s);
extern wv_stack_t __LIB__              *wv_stack_init(void *p, size_t capacity, size_t max_size);
extern size_t     __LIB__ __FASTCALL__  wv_stack_max_size(wv_stack_t *s);
extern void       __LIB__ __FASTCALL__ *wv_stack_pop(wv_stack_t *s);
extern int        __LIB__               wv_stack_push(wv_stack_t *s, void *item);
extern int        __LIB__               wv_stack_reserve(wv_stack_t *s, size_t n);
extern int        __LIB__ __FASTCALL__  wv_stack_shrink_to_fit(wv_stack_t *s);
extern size_t     __LIB__ __FASTCALL__  wv_stack_size(wv_stack_t *s);
extern void       __LIB__ __FASTCALL__ *wv_stack_top(wv_stack_t *s);

// SCCZ80 CALLEE LINKAGE

extern wv_stack_t __LIB__ __CALLEE__   *wv_stack_init_callee(void *p, size_t capacity, size_t max_size);
extern int        __LIB__ __CALLEE__    wv_stack_push_callee(wv_stack_t *s, void *item);
extern int        __LIB__ __CALLEE__    wv_stack_reserve_callee(wv_stack_t *s, size_t n);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define wv_stack_init(a,b,c)                     wv_stack_init_callee(a,b,c)
#define wv_stack_push(a,b)                       wv_stack_push_callee(a,b)
#define wv_stack_reserve(a,b)                    wv_stack_reserve_callee(a,b)

#endif

#endif
