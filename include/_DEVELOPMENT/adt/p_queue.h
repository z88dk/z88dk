
#ifndef _ADT_P_QUEUE_H
#define _ADT_P_QUEUE_H

#include <_DEVELOPMENT/stddef.h>

// DATA STRUCTURES

typedef struct p_queue_s
{
   void       *head;
   void       *tail;

} p_queue_t;

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
