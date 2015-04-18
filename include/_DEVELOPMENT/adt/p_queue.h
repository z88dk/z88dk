
#ifndef _ADT_P_QUEUE_H
#define _ADT_P_QUEUE_H

#include <stddef.h>

// DATA STRUCTURES

typedef struct p_queue_s
{
   void       *head;
   void       *tail;

} p_queue_t;

#ifdef __SDCC

// SDCC

extern void       *p_queue_back(p_queue_t *q);
extern void        p_queue_clear(p_queue_t *q);
extern int         p_queue_empty(p_queue_t *q);
extern void       *p_queue_front(p_queue_t *q);
extern void        p_queue_init(void *p);
extern void       *p_queue_pop(p_queue_t *q);
extern void        p_queue_push(p_queue_t *q, void *item);
extern size_t      p_queue_size(p_queue_t *q);

#ifdef __SDCC_ENABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern void       *p_queue_back_fastcall(p_queue_t *q) __z88dk_fastcall;
extern void        p_queue_clear_fastcall(p_queue_t *q) __z88dk_fastcall;
extern int         p_queue_empty_fastcall(p_queue_t *q) __z88dk_fastcall;
extern void       *p_queue_front_fastcall(p_queue_t *q) __z88dk_fastcall;
extern void        p_queue_init_fastcall(void *p) __z88dk_fastcall;
extern void       *p_queue_pop_fastcall(p_queue_t *q) __z88dk_fastcall;
extern size_t      p_queue_size_fastcall(p_queue_t *q) __z88dk_fastcall;

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define p_queue_back(a)                 p_queue_back_fastcall(a)
#define p_queue_clear(a)                p_queue_clear_fastcall(a)
#define p_queue_empty(a)                p_queue_empty_fastcall(a)
#define p_queue_front(a)                p_queue_front_fastcall(a)
#define p_queue_init(a)                 p_queue_init_fastcall(a)
#define p_queue_pop(a)                  p_queue_pop_fastcall(a)
#define p_queue_size(a)                 p_queue_size_fastcall(a)

#endif

#else

// SCCZ80

extern void       __LIB__ __FASTCALL__ *p_queue_back(p_queue_t *q);
extern void       __LIB__ __FASTCALL__  p_queue_clear(p_queue_t *q);
extern int        __LIB__ __FASTCALL__  p_queue_empty(p_queue_t *q);
extern void       __LIB__ __FASTCALL__ *p_queue_front(p_queue_t *q);
extern void       __LIB__ __FASTCALL__  p_queue_init(void *p);
extern void       __LIB__ __FASTCALL__ *p_queue_pop(p_queue_t *q);
extern void       __LIB__               p_queue_push(p_queue_t *q, void *item);
extern size_t     __LIB__ __FASTCALL__  p_queue_size(p_queue_t *q);

// SCCZ80 CALLEE LINKAGE

extern void       __LIB__ __CALLEE__    p_queue_push_callee(p_queue_t *q, void *item);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define p_queue_push(a,b)                        p_queue_push_callee(a,b)

#endif

#endif
