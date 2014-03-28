
#ifndef _ADT_P_LIST_H
#define _ADT_P_LIST_H

#include <_DEVELOPMENT/stddef.h>

// DATA STRUCTURES

typedef struct p_list_s
{

   void       *head;
   void       *tail;

} p_list_t;

// SCCZ80

extern void       __LIB__ __FASTCALL__ *p_list_back(p_list_t *ls);
extern void       __LIB__ __FASTCALL__  p_list_clear(p_list_t *ls);
extern int        __LIB__ __FASTCALL__  p_list_empty(p_list_t *ls);
extern void       __LIB__ __FASTCALL__ *p_list_front(p_list_t *ls);
extern void       __LIB__ __FASTCALL__  p_list_init(void *p);
extern void       __LIB__              *p_list_insert(p_list_t *ls, void *ls_item, void *item);
extern void       __LIB__              *p_list_insert_after(p_list_t *ls, void *ls_item, void *item);
extern void       __LIB__ __FASTCALL__ *p_list_pop_back(p_list_t *ls);
extern void       __LIB__ __FASTCALL__ *p_list_pop_front(p_list_t *ls);
extern void       __LIB__              *p_list_push_back(p_list_t *ls, void *item);
extern void       __LIB__              *p_list_push_front(p_list_t *ls, void *item);
extern void       __LIB__              *p_list_remove(p_list_t *ls, void *item);
extern void       __LIB__              *p_list_remove_after(p_list_t *ls, void *ls_item);
extern size_t     __LIB__ __FASTCALL__  p_list_size(p_list_t *ls);

// SCCZ80 CALLEE LINKAGE

extern void       __LIB__ __CALLEE__   *p_list_insert_callee(p_list_t *ls, void *ls_item, void *item);
extern void       __LIB__ __CALLEE__   *p_list_insert_after_callee(p_list_t *ls, void *ls_item, void *item);
extern void       __LIB__ __CALLEE__   *p_list_push_back_callee(p_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_list_push_front_callee(p_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_list_remove_callee(p_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_list_remove_after_callee(p_list_t *ls, void *ls_item);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define p_list_insert(a,b,c)                     p_list_insert_callee(a,b,c)
#define p_list_insert_after(a,b,c)               p_list_insert_after_callee(a,b,c)
#define p_list_push_back(a,b)                    p_list_push_back_callee(a,b)
#define p_list_push_front(a,b)                   p_list_push_front_callee(a,b)
#define p_list_remove(a,b)                       p_list_remove_callee(a,b)
#define p_list_remove_after(a,b)                 p_list_remove_after_callee(a,b)

#endif
