
#ifndef _ADT_WA_PRIORITY_QUEUE_H
#define _ADT_WA_PRIORITY_QUEUE_H

#include <_DEVELOPMENT/stddef.h>

// DATA STRUCTURES

typedef struct wa_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;

} wa_priority_queue_t;

#ifdef __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern size_t               wa_priority_queue_capacity(wa_priority_queue_t *q);
extern void                 wa_priority_queue_clear(wa_priority_queue_t *q);
extern void                *wa_priority_queue_data(wa_priority_queue_t *q);
extern void                 wa_priority_queue_destroy(wa_priority_queue_t *q);
extern int                  wa_priority_queue_empty(wa_priority_queue_t *q);
extern wa_priority_queue_t *wa_priority_queue_init(void *p, void *data, size_t capacity, void *compar);
extern void                *wa_priority_queue_pop(wa_priority_queue_t *q);
extern int                  wa_priority_queue_push(wa_priority_queue_t *q, void *item);
extern int                  wa_priority_queue_resize(wa_priority_queue_t *q, size_t n);
extern size_t               wa_priority_queue_size(wa_priority_queue_t *q);
extern void                *wa_priority_queue_top(wa_priority_queue_t *q);

#else

// SCCZ80

extern size_t              __LIB__ __FASTCALL__  wa_priority_queue_capacity(wa_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  wa_priority_queue_clear(wa_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__ *wa_priority_queue_data(wa_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  wa_priority_queue_destroy(wa_priority_queue_t *q);
extern int                 __LIB__ __FASTCALL__  wa_priority_queue_empty(wa_priority_queue_t *q);
extern wa_priority_queue_t __LIB__ __FASTCALL__ *wa_priority_queue_init(void *p, void *data, size_t capacity, void *compar);
extern void                __LIB__ __FASTCALL__ *wa_priority_queue_pop(wa_priority_queue_t *q);
extern int                 __LIB__               wa_priority_queue_push(wa_priority_queue_t *q, void *item);
extern int                 __LIB__               wa_priority_queue_resize(wa_priority_queue_t *q, size_t n);
extern size_t              __LIB__ __FASTCALL__  wa_priority_queue_size(wa_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__ *wa_priority_queue_top(wa_priority_queue_t *q);

// SCCZ80 CALLEE LINKAGE

extern int                 __LIB__ __CALLEE__    wa_priority_queue_push_callee(wa_priority_queue_t *q, void *item);
extern int                 __LIB__ __CALLEE__    wa_priority_queue_resize_callee(wa_priority_queue_t *q, size_t n);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define wa_priority_queue_push(a,b)              wa_priority_queue_push_callee(a,b)
#define wa_priority_queue_resize(a,b)            wa_priority_queue_resize_callee(a,b)

#endif
#endif
