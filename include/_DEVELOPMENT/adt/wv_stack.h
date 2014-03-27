
#ifndef _ADT_WV_STACK_H
#define _ADT_WV_STACK_H

// DATA STRUCTURES

typedef struct wv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_stack_t;

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
