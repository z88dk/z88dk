
#ifndef _ADT_WV_PRIORITY_QUEUE_H
#define _ADT_WV_PRIORITY_QUEUE_H

#include <_DEVELOPMENT/stddef.h>

// DATA STRUCTURES

typedef struct wv_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_priority_queue_t;

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern size_t               wv_priority_queue_capacity(wv_priority_queue_t *q);
extern void                 wv_priority_queue_clear(wv_priority_queue_t *q);
extern void                *wv_priority_queue_data(wv_priority_queue_t *q);
extern void                 wv_priority_queue_destroy(wv_priority_queue_t *q);
extern int                  wv_priority_queue_empty(wv_priority_queue_t *q);
extern wv_priority_queue_t *wv_priority_queue_init(void *p, size_t capacity, size_t max_size, void *compar);
extern size_t               wv_priority_queue_max_size(wv_priority_queue_t *q);
extern void                *wv_priority_queue_pop(wv_priority_queue_t *q);
extern int                  wv_priority_queue_push(wv_priority_queue_t *q, void *item);
extern int                  wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n);
extern int                  wv_priority_queue_resize(wv_priority_queue_t *q, size_t n);
extern int                  wv_priority_queue_shrink_to_fit(wv_priority_queue_t *q);
extern size_t               wv_priority_queue_size(wv_priority_queue_t *q);
extern void                *wv_priority_queue_top(wv_priority_queue_t *q);

#else

// SCCZ80

extern size_t              __LIB__ __FASTCALL__  wv_priority_queue_capacity(wv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  wv_priority_queue_clear(wv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__ *wv_priority_queue_data(wv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  wv_priority_queue_destroy(wv_priority_queue_t *q);
extern int                 __LIB__ __FASTCALL__  wv_priority_queue_empty(wv_priority_queue_t *q);
extern wv_priority_queue_t __LIB__              *wv_priority_queue_init(void *p, size_t capacity, size_t max_size, void *compar);
extern size_t              __LIB__ __FASTCALL__  wv_priority_queue_max_size(wv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__ *wv_priority_queue_pop(wv_priority_queue_t *q);
extern int                 __LIB__               wv_priority_queue_push(wv_priority_queue_t *q, void *item);
extern int                 __LIB__               wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n);
extern int                 __LIB__               wv_priority_queue_resize(wv_priority_queue_t *q, size_t n);
extern int                 __LIB__ __FASTCALL__  wv_priority_queue_shrink_to_fit(wv_priority_queue_t *q);
extern size_t              __LIB__ __FASTCALL__  wv_priority_queue_size(wv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__ *wv_priority_queue_top(wv_priority_queue_t *q);

// SCCZ80 CALLEE LINKAGE

extern wv_priority_queue_t __LIB__ __CALLEE__   *wv_priority_queue_init_callee(void *p, size_t capacity, size_t max_size, void *compar);
extern int                 __LIB__ __CALLEE__    wv_priority_queue_push_callee(wv_priority_queue_t *q, void *item);
extern int                 __LIB__ __CALLEE__    wv_priority_queue_reserve_callee(wv_priority_queue_t *q, size_t n);
extern int                 __LIB__ __CALLEE__    wv_priority_queue_resize_callee(wv_priority_queue_t *q, size_t n);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define wv_priority_queue_init(a,b,c,d)          wv_priority_queue_init_callee(a,b,c,d)
#define wv_priority_queue_push(a,b)              wv_priority_queue_push_callee(a,b)
#define wv_priority_queue_reserve(a,b)           wv_priority_queue_reserve_callee(a,b)
#define wv_priority_queue_resize(a,b)            wv_priority_queue_resize_callee(a,b)

#endif

#endif
