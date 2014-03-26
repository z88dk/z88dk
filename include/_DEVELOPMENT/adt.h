
#ifndef _ADT_H
#define _ADT_H

// DATA STRUCTURES

typdef struct b_array_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} b_array_t;

typedef struct b_vector_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} b_vector_t;

typedef struct ba_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;

} ba_priority_queue_t;

typedef struct ba_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} ba_stack_t;

typedef struct bv_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} bv_priority_queue_t;

typedef struct bv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} bv_stack_t;

typedef void* p_forward_list_t;

typedef struct p_forward_list_alt_s
{

   void       *head;
   void       *tail;

} p_forward_list_alt_t;

typedef struct p_list_s
{

   void       *head;
   void       *tail;

} p_list_t;

typedef struct p_queue_s
{
   void       *head;
   void       *tail;

} p_queue_t;

typedef void* p_stack_t;

typedef struct w_array_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} w_array_t;

typedef struct w_vector_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} w_vector_t;

typedef struct wa_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;

} wa_priority_queue_t;

typedef struct wa_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;

} wa_stack_t;

typedef struct wv_priority_queue_s
{

   void       *compar;
   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_priority_queue_t;

typedef struct wv_stack_s
{

   void       *data;
   size_t      size;
   size_t      capacity;
   size_t      max_size;

} wv_stack_t;

// SCCZ80

// b_array

extern size_t    __LIB__               b_array_append(b_array_t *a, int c);
extern void      __LIB__              *b_array_append_block(b_array_t *a, size_t n);
extern size_t    __LIB__               b_array_append_n(b_array_t *a, size_t n, int c);
extern int       __LIB__               b_array_at(b_array_t *a, size_t idx);
extern int       __LIB__ __FASTCALL__  b_array_back(b_array_t *a);
extern size_t    __LIB__ __FASTCALL__  b_array_capacity(b_array_t *a);
extern void      __LIB__ __FASTCALL__  b_array_clear(b_array_t *a);
extern void      __LIB__ __FASTCALL__ *b_array_data(b_array_t *a);
extern void      __LIB__ __FASTCALL__  b_array_destroy(b_array_t *a);
extern int       __LIB__ __FASTCALL__  b_array_empty(b_array_t *a);
extern size_t    __LIB__               b_array_erase(b_array_t *a, size_t idx);
extern size_t    __LIB__               b_array_erase_block(b_array_t *a, size_t idx, size_t n);
extern size_t    __LIB__               b_array_erase_range(b_array_t *a, size_t idx_first, size_t idx_last);
extern int       __LIB__ __FASTCALL__  b_array_front(b_array_t *a);
extern b_array_t __LIB__              *b_array_init(void *p, void *data, size_t capacity);
extern size_t    __LIB__               b_array_insert(b_array_t *a, size_t idx, int c);
extern void      __LIB__              *b_array_insert_block(b_array_t *a, size_t idx, size_t n);
extern size_t    __LIB__               b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c);
extern int       __LIB__ __FASTCALL__  b_array_pop_back(b_array_t *a);
extern size_t    __LIB__               b_array_push_back(b_array_t *a, int c);
extern size_t    __LIB__               b_array_read_block(void *dst, size_t n, b_array_t *a, size_t idx);
extern int       __LIB__               b_array_resize(b_array_t *a, size_t n);
extern size_t    __LIB__ __FASTCALL__  b_array_size(b_array_t *a);
extern size_t    __LIB__               b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx);

// b_vector

extern size_t     __LIB__               b_vector_append(b_vector_t *v, int c);
extern void       __LIB__              *b_vector_append_block(b_vector_t *v, size_t n);
extern size_t     __LIB__               b_vector_append_n(b_vector_t *v, size_t n, int c);
extern int        __LIB__               b_vector_at(b_vector_t *v, size_t idx);
extern int        __LIB__ __FASTCALL__  b_vector_back(b_vector_t *v);
extern size_t     __LIB__ __FASTCALL__  b_vector_capacity(b_vector_t *v);
extern void       __LIB__ __FASTCALL__  b_vector_clear(b_vector_t *v);
extern void       __LIB__ __FASTCALL__ *b_vector_data(b_vector_t *v);
extern void       __LIB__ __FASTCALL__  b_vector_destroy(b_vector_t *v);
extern int        __LIB__ __FASTCALL__  b_vector_empty(b_vector_t *v);
extern size_t     __LIB__               b_vector_erase(b_vector_t *v, size_t idx);
extern size_t     __LIB__               b_vector_erase_block(b_vector_t *v, size_t idx, size_t n);
extern size_t     __LIB__               b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last);
extern int        __LIB__ __FASTCALL__  b_vector_front(b_vector_t *v);
extern b_vector_t __LIB__               b_vector_init(void *p, size_t capacity, size_t max_size);
extern size_t     __LIB__               b_vector_insert(b_vector_t *v, size_t idx, int c);
extern void       __LIB__              *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n);
extern size_t     __LIB__               b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c);
extern size_t     __LIB__ __FASTCALL__  b_vector_max_size(b_vector_t *v);
extern int        __LIB__ __FASTCALL__  b_vector_pop_back(b_vector_t *v);
extern size_t     __LIB__               b_vector_push_back(b_vector_t *v, int c);
extern size_t     __LIB__               b_vector_read_block(void *dst, size_t n, b_vector *v, size_t idx);
extern int        __LIB__               b_vector_reserve(b_vector_t *v, size_t n);
extern int        __LIB__               b_vector_resize(b_vector_t *v, size_t n);
extern int        __LIB__ __FASTCALL__  b_vector_shrink_to_fit(b_vector_t *);
extern size_t     __LIB__ __FASTCALL__  b_vector_size(b_vector_t *v);
extern size_t     __LIB__               b_vector_write_block(void *src, size_t n, b_vector_t *v, size_t idx);

// ba_priority_queue

extern size_t              __LIB__ __FASTCALL__  ba_priority_queue_capacity(ba_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  ba_priority_queue_clear(ba_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__ *ba_priority_queue_data(ba_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  ba_priority_queue_destroy(ba_priority_queue_t *q);
extern int                 __LIB__ __FASTCALL__  ba_priority_queue_empty(ba_priority_queue_t *q);
extern ba_priority_queue_t __LIB__              *ba_priority_queue_init(void *p, void *data, size_t capacity, void *compar);
extern int                 __LIB__ __FASTCALL__  ba_priority_queue_pop(ba_priority_queue_t *q);
extern int                 __LIB__               ba_priority_queue_push(ba_priority_queue_t *q, int c);
extern int                 __LIB__               ba_priority_queue_resize(ba_priority_queue_t *q, size_t n);
extern size_t              __LIB__ __FASTCALL__  ba_priority_queue_size(ba_priority_queue_t *q);
extern int                 __LIB__ __FASTCALL__  ba_priority_queue_top(ba_priority_queue_t *q);

// ba_stack

extern size_t     __LIB__ __FASTCALL__  ba_stack_capacity(ba_stack_t *s);
extern void       __LIB__ __FASTCALL__  ba_stack_clear(ba_stack_t *s);
extern void       __LIB__ __FASTCALL__  ba_stack_destroy(ba_stack_t *s);
extern int        __LIB__ __FASTCALL__  ba_stack_empty(ba_stack_t *s);
extern ba_stack_t __LIB__              *ba_stack_init(void *p, void *data, size_t capacity);
extern int        __LIB__ __FASTCALL__  ba_stack_pop(ba_stack_t *s);
extern int        __LIB__               ba_stack_push(ba_stack_t *s, int c);
extern size_t     __LIB__ __FASTCALL__  ba_stack_size(ba_stack_t *s);
extern int        __LIB__ __FASTCALL__  ba_stack_top(ba_stack_t *s);

// bv_priority_queue

extern size_t              __LIB__ __FASTCALL__  bv_priority_queue_capacity(bv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  bv_priority_queue_clear(bv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__ *bv_priority_queue_data(bv_priority_queue_t *q);
extern void                __LIB__ __FASTCALL__  bv_priority_queue_destroy(bv_priority_queue_t *q);
extern int                 __LIB__ __FASTCALL__  bv_priority_queue_empty(bv_priority_queue_t *q);
extern bv_priority_queue_t __LIB__              *bv_priority_queue_init(void *p, size_t capacity, size_t max_size, void *compar);
extern size_t              __LIB__ __FASTCALL__  bv_priority_queue_max_size(bv_priority_queue_t *q);
extern int                 __LIB__ __FASTCALL__  bv_priority_queue_pop(bv_priority_queue_t *q);
extern int                 __LIB__               bv_priority_queue_push(bv_priority_queue_t *q, int c);
extern int                 __LIB__               bv_priority_queue_reserve(bv_priority_queue_t *q, size_t n);
extern int                 __LIB__               bv_priority_queue_resize(bv_priority_queue_t *q, size_t n);
extern int                 __LIB__ __FASTCALL__  bv_priority_queue_shrink_to_fit(bv_priority_queue_t *q);
extern size_t              __LIB__ __FASTCALL__  bv_priority_queue_size(bv_priority_queue_t *q);
extern int                 __LIB__ __FASTCALL__  bv_priority_queue_top(bv_priority_queue_t *q);

// bv_stack

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

// p_forward_list

extern void       __LIB__ __FASTCALL__ *p_forward_list_back(p_forward_list_t *ls);
extern void       __LIB__ __FASTCALL__  p_forward_list_clear(p_forward_list_t *ls);
extern int        __LIB__ __FASTCALL__  p_forward_list_empty(p_forward_list_t *ls);
extern void       __LIB__ __FASTCALL__ *p_forward_list_front(p_forward_list_t *ls);
extern void       __LIB__ __FASTCALL__  p_forward_list_init(void *p);
extern void       __LIB__              *p_forward_list_insert_after(void *ls_item, void *item);
extern void       __LIB__ __FASTCALL__ *p_forward_list_pop_back(p_forward_list_t *ls);
extern void       __LIB__ __FASTCALL__ *p_forward_list_pop_front(p_forward_list_t *ls);
extern void       __LIB__               p_forward_list_push_back(p_forward_list_t *ls, void *item);
extern void       __LIB__               p_forward_list_push_front(p_forward_list_t *ls, void *item);
extern void       __LIB__              *p_forward_list_remove(p_forward_list_t *ls, void *item);
extern void       __LIB__ __FASTCALL__ *p_forward_list_remove_after(void *ls_item);
extern size_t     __LIB__ __FASTCALL__  p_forward_list_size(p_forward_list_t *ls);

// p_forward_list_alt

extern void       __LIB__ __FASTCALL__ *p_forward_list_alt_back(p_forward_list_alt_t *ls);
extern void       __LIB__ __FASTCALL__  p_forward_list_alt_clear(p_forward_list_alt_t *ls);
extern int        __LIB__ __FASTCALL__  p_forward_list_alt_empty(p_forward_list_alt_t *ls);
extern void       __LIB__ __FASTCALL__ *p_forward_list_alt_front(p_forward_list_alt_t *ls);
extern void       __LIB__ __FASTCALL__  p_forward_list_alt_init(void *p);
extern void       __LIB__              *p_forward_list_alt_insert_after(p_forward_list_alt *ls, void *ls_item, void *item);
extern void       __LIB__ __FASTCALL__ *p_forward_list_alt_pop_back(p_forward_list_alt_t *ls);
extern void       __LIB__ __FASTCALL__ *p_forward_list_alt_pop_front(p_forward_list_alt_t *ls);
extern void       __LIB__               p_forward_list_alt_push_back(p_forward_list_alt_t *ls, void *item);
extern void       __LIB__               p_forward_list_alt_push_front(p_forward_list_alt_t *ls, void *item);
extern void       __LIB__              *p_forward_list_alt_remove(p_forward_list_alt_t *ls, void *item);
extern void       __LIB__              *p_forward_list_alt_remove_after(p_forward_list_alt *ls, void *ls_item);
extern size_t     __LIB__ __FASTCALL__  p_forward_list_alt_size(p_forward_list_alt_t *ls);

// p_list

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

// p_queue

extern void       __LIB__ __FASTCALL__ *p_queue_back(p_queue_t *q);
extern void       __LIB__ __FASTCALL__  p_queue_clear(p_queue_t *q);
extern int        __LIB__ __FASTCALL__  p_queue_empty(p_queue_t *q);
extern void       __LIB__ __FASTCALL__ *p_queue_front(p_queue_t *q);
extern void       __LIB__ __FASTCALL__  p_queue_init(void *p);
extern void       __LIB__ __FASTCALL__ *p_queue_pop(p_queue_t *q);
extern void       __LIB__               p_queue_push(p_queue_t *q, void *item);
extern size_t     __LIB__ __FASTCALL__  p_queue_size(p_queue_t *q);

// p_stack

extern void       __LIB__ __FASTCALL__  p_stack_clear(p_stack_t *s);
extern int        __LIB__ __FASTCALL__  p_stack_empty(p_stack_t *s);
extern void       __LIB__ __FASTCALL__  p_stack_init(void *p);
extern void       __LIB__ __FASTCALL__ *p_stack_pop(p_stack_t *s);
extern void       __LIB__               p_stack_push(p_stack_t *s, void *item);
extern size_t     __LIB__ __FASTCALL__  p_stack_size(p_stack_t *s);
extern void       __LIB__ __FASTCALL__ *p_stack_top(p_stack_t *s);

// w_array

extern size_t     __LIB__               w_array_append(w_array_t *a, void *item);
extern size_t     __LIB__               w_array_append_n(w_array_t *a, size_t n, void *item);
extern void       __LIB__              *w_array_at(w_array_t *a, size_t idx);
extern void       __LIB__ __FASTCALL__ *w_array_back(w_array_t *a);
extern size_t     __LIB__ __FASTCALL__  w_array_capacity(w_array_t *a);
extern void       __LIB__ __FASTCALL__  w_array_clear(w_array_t *a);
extern void       __LIB__ __FASTCALL__ *w_array_data(w_array_t *a);
extern void       __LIB__ __FASTCALL__  w_array_destroy(w_array_t *a);
extern int        __LIB__ __FASTCALL__  w_array_empty(w_array_t *a);
extern size_t     __LIB__               w_array_erase(w_array_t *a, size_t idx);
extern size_t     __LIB__               w_array_erase_range(w_array_t *a, size_t idx_first, size_t idx_last);
extern void       __LIB__ __FASTCALL__ *w_array_front(w_array_t *a);
extern w_array_t  __LIB__              *w_array_init(void *p, void *data, size_t capacity);
extern size_t     __LIB__               w_array_insert(w_array_t *a, size_t idx, void *item);
extern size_t     __LIB__               w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item);
extern void       __LIB__ __FASTCALL__ *w_array_pop_back(w_array_t *a);
extern size_t     __LIB__               w_array_push_back(w_array_t *a, void *item);
extern int        __LIB__               w_array_resize(w_array_t *a, size_t n);
extern size_t     __LIB__ __FASTCALL__  w_array_size(w_array_t *a);

// w_vector

extern size_t     __LIB__               w_vector_append(w_vector_t *v, void *item);
extern size_t     __LIB__               w_vector_append_n(w_vector_t *v, size_t n, void *item);
extern void       __LIB__               w_vector_at(w_vector_t *v, size_t idx);
extern void       __LIB__ __FASTCALL__ *w_vector_back(w_vector_t *v);
extern size_t     __LIB__ __FASTCALL__  w_vector_capacity(w_vector_t *v);
extern void       __LIB__ __FASTCALL__  w_vector_clear(w_vector_t *v);
extern void       __LIB__ __FASTCALL__ *w_vector_data(w_vector_t *v);
extern void       __LIB__ __FASTCALL__  w_vector_destroy(w_vector_t *v);
extern void       __LIB__ __FASTCALL__  w_vector_empty(w_vector_t *v);
extern size_t     __LIB__               w_vector_erase(w_vector_t *v, size_t idx);
extern size_t     __LIB__               w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last);
extern void       __LIB__ __FASTCALL__ *w_vector_front(w_vector_t *v);
extern w_vector_t __LIB__              *w_vector_init(void *p, size_t capacity, size_t max_size);
extern size_t     __LIB__               w_vector_insert(w_vector_t *v, size_t idx, void *item);
extern size_t     __LIB__               w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item);
extern void       __LIB__ __FASTCALL__ *w_vector_max_size(w_vector_t *v);
extern void       __LIB__ __FASTCALL__ *w_vector_pop_back(w_vector_t *v);
extern size_t     __LIB__               w_vector_push_back(w_vector_t *v, void *item);
extern int        __LIB__               w_vector_reserve(w_vector_t *v, size_t n);
extern int        __LIB__               w_vector_resize(w_vector_t *v, size_t n);
extern int        __LIB__ __FASTCALL__  w_vector_shrink_to_fit(w_vector_t *v);
extern size_t     __LIB__ __FASTCALL__  w_vector_size(w_vector_t *v);

// wa_priority_queue

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

// wa_stack

extern size_t     __LIB__ __FASTCALL__  wa_stack_capacity(wa_stack_t *s);
extern void       __LIB__ __FASTCALL__  wa_stack_clear(wa_stack_t *s);
extern void       __LIB__ __FASTCALL__  wa_stack_destroy(wa_stack_t *s);
extern int        __LIB__ __FASTCALL__  wa_stack_empty(wa_stack_t *s);
extern wa_stack_t __LIB__              *wa_stack_init(void *p, void *data, size_t capacity);
extern void       __LIB__ __FASTCALL__ *wa_stack_pop(wa_stack_t *s);
extern int        __LIB__               wa_stack_push(wa_stack_t *s, void *item);
extern size_t     __LIB__ __FASTCALL__  wa_stack_size(wa_stack_t *s);
extern void       __LIB__ __FASTCALL__ *wa_stack_top(wa_stack_t *s);

// wv_priority_queue

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

// wv_stack

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

// b_array

extern size_t    __LIB__ __CALLEE__    b_array_append_callee(b_array_t *a, int c);
extern void      __LIB__ __CALLEE__   *b_array_append_block_callee(b_array_t *a, size_t n);
extern size_t    __LIB__ __CALLEE__    b_array_append_n_callee(b_array_t *a, size_t n, int c);
extern int       __LIB__ __CALLEE__    b_array_at_callee(b_array_t *a, size_t idx);
extern size_t    __LIB__ __CALLEE__    b_array_erase_callee(b_array_t *a, size_t idx);
extern size_t    __LIB__ __CALLEE__    b_array_erase_block_callee(b_array_t *a, size_t idx, size_t n);
extern size_t    __LIB__ __CALLEE__    b_array_erase_range_callee(b_array_t *a, size_t idx_first, size_t idx_last);
extern b_array_t __LIB__ __CALLEE__   *b_array_init_callee(void *p, void *data, size_t capacity);
extern size_t    __LIB__ __CALLEE__    b_array_insert_callee(b_array_t *a, size_t idx, int c);
extern void      __LIB__ __CALLEE__   *b_array_insert_block_callee(b_array_t *a, size_t idx, size_t n);
extern size_t    __LIB__ __CALLEE__    b_array_insert_n_callee(b_array_t *a, size_t idx, size_t n, int c);
extern size_t    __LIB__ __CALLEE__    b_array_push_back_callee(b_array_t *a, int c);
extern size_t    __LIB__ __CALLEE__    b_array_read_block_callee(void *dst, size_t n, b_array_t *a, size_t idx);
extern int       __LIB__ __CALLEE__    b_array_resize_callee(b_array_t *a, size_t n);
extern size_t    __LIB__ __CALLEE__    b_array_write_block_callee(void *src, size_t n, b_array_t *a, size_t idx);

// b_vector

extern size_t     __LIB__ __CALLEE__    b_vector_append_callee(b_vector_t *v, int c);
extern void       __LIB__ __CALLEE__   *b_vector_append_block_callee(b_vector_t *v, size_t n);
extern size_t     __LIB__ __CALLEE__    b_vector_append_n_callee(b_vector_t *v, size_t n, int c);
extern int        __LIB__ __CALLEE__    b_vector_at_callee(b_vector_t *v, size_t idx);
extern size_t     __LIB__ __CALLEE__    b_vector_erase_callee(b_vector_t *v, size_t idx);
extern size_t     __LIB__ __CALLEE__    b_vector_erase_block_callee(b_vector_t *v, size_t idx, size_t n);
extern size_t     __LIB__ __CALLEE__    b_vector_erase_range_callee(b_vector_t *v, size_t idx_first, size_t idx_last);
extern b_vector_t __LIB__ __CALLEE__    b_vector_init_callee(void *p, size_t capacity, size_t max_size);
extern size_t     __LIB__ __CALLEE__    b_vector_insert_callee(b_vector_t *v, size_t idx, int c);
extern void       __LIB__ __CALLEE__   *b_vector_insert_block_callee(b_vector_t *v, size_t idx, size_t n);
extern size_t     __LIB__ __CALLEE__    b_vector_insert_n_callee(b_vector_t *v, size_t idx, size_t n, int c);
extern size_t     __LIB__ __CALLEE__    b_vector_push_back_callee(b_vector_t *v, int c);
extern size_t     __LIB__ __CALLEE__    b_vector_read_block_callee(void *dst, size_t n, b_vector *v, size_t idx);
extern int        __LIB__ __CALLEE__    b_vector_reserve_callee(b_vector_t *v, size_t n);
extern int        __LIB__ __CALLEE__    b_vector_resize_callee(b_vector_t *v, size_t n);
extern size_t     __LIB__ __CALLEE__    b_vector_write_block_callee(void *src, size_t n, b_vector_t *v, size_t idx);

// ba_priority_queue

extern ba_priority_queue_t __LIB__ __CALLEE__   *ba_priority_queue_init_callee(void *p, void *data, size_t capacity, void *compar);
extern int                 __LIB__ __CALLEE__    ba_priority_queue_push_callee(ba_priority_queue_t *q, int c);
extern int                 __LIB__ __CALLEE__    ba_priority_queue_resize_callee(ba_priority_queue_t *q, size_t n);

// ba_stack

extern ba_stack_t __LIB__ __CALLEE__   *ba_stack_init_callee(void *p, void *data, size_t capacity);
extern int        __LIB__ __CALLEE__    ba_stack_push_callee(ba_stack_t *s, int c);

// bv_priority_queue

extern bv_priority_queue_t __LIB__ __CALLEE__   *bv_priority_queue_init_callee(void *p, size_t capacity, size_t max_size, void *compar);
extern int                 __LIB__ __CALLEE__    bv_priority_queue_push_callee(bv_priority_queue_t *q, int c);
extern int                 __LIB__ __CALLEE__    bv_priority_queue_reserve_callee(bv_priority_queue_t *q, size_t n);
extern int                 __LIB__ __CALLEE__    bv_priority_queue_resize_callee(bv_priority_queue_t *q, size_t n);

// bv_stack

extern bv_stack_t __LIB__ __CALLEE__   *bv_stack_init_callee(void *p, size_t capacity, size_t max_size);
extern int        __LIB__ __CALLEE__    bv_stack_push_callee(bv_stack_t *s, int c);
extern int        __LIB__ __CALLEE__    bv_stack_reserve_callee(bv_stack_t *s, size_t n);

// p_forward_list

extern void       __LIB__ __CALLEE__   *p_forward_list_insert_after_callee(void *ls_item, void *item);
extern void       __LIB__ __CALLEE__    p_forward_list_push_back_callee(p_forward_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__    p_forward_list_push_front_callee(p_forward_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_forward_list_remove_callee(p_forward_list_t *ls, void *item);

// p_forward_list_alt

extern void       __LIB__ __CALLEE__   *p_forward_list_alt_insert_after_callee(p_forward_list_alt *ls, void *ls_item, void *item);
extern void       __LIB__ __CALLEE__    p_forward_list_alt_push_back_callee(p_forward_list_alt_t *ls, void *item);
extern void       __LIB__ __CALLEE__    p_forward_list_alt_push_front_callee(p_forward_list_alt_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_forward_list_alt_remove_callee(p_forward_list_alt_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_forward_list_alt_remove_after_callee(p_forward_list_alt *ls, void *ls_item);

// p_list

extern void       __LIB__ __CALLEE__   *p_list_insert_callee(p_list_t *ls, void *ls_item, void *item);
extern void       __LIB__ __CALLEE__   *p_list_insert_after_callee(p_list_t *ls, void *ls_item, void *item);
extern void       __LIB__ __CALLEE__   *p_list_push_back_callee(p_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_list_push_front_callee(p_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_list_remove_callee(p_list_t *ls, void *item);
extern void       __LIB__ __CALLEE__   *p_list_remove_after_callee(p_list_t *ls, void *ls_item);

// p_queue

extern void       __LIB__ __CALLEE__    p_queue_push_callee(p_queue_t *q, void *item);

// p_stack

extern void       __LIB__ __CALLEE__    p_stack_push_callee(p_stack_t *s, void *item);

// w_array

extern size_t     __LIB__ __CALLEE__    w_array_append_callee(w_array_t *a, void *item);
extern size_t     __LIB__ __CALLEE__    w_array_append_n_callee(w_array_t *a, size_t n, void *item);
extern void       __LIB__ __CALLEE__   *w_array_at_callee(w_array_t *a, size_t idx);
extern size_t     __LIB__ __CALLEE__    w_array_erase_callee(w_array_t *a, size_t idx);
extern size_t     __LIB__ __CALLEE__    w_array_erase_range_callee(w_array_t *a, size_t idx_first, size_t idx_last);
extern w_array_t  __LIB__ __CALLEE__   *w_array_init_callee(void *p, void *data, size_t capacity);
extern size_t     __LIB__ __CALLEE__    w_array_insert_callee(w_array_t *a, size_t idx, void *item);
extern size_t     __LIB__ __CALLEE__    w_array_insert_n_callee(w_array_t *a, size_t idx, size_t n, void *item);
extern size_t     __LIB__ __CALLEE__    w_array_push_back_callee(w_array_t *a, void *item);
extern int        __LIB__ __CALLEE__    w_array_resize_callee(w_array_t *a, size_t n);

// w_vector

extern size_t     __LIB__ __CALLEE__    w_vector_append_callee(w_vector_t *v, void *item);
extern size_t     __LIB__ __CALLEE__    w_vector_append_n_callee(w_vector_t *v, size_t n, void *item);
extern void       __LIB__ __CALLEE__    w_vector_at_callee(w_vector_t *v, size_t idx);
extern size_t     __LIB__ __CALLEE__    w_vector_erase_callee(w_vector_t *v, size_t idx);
extern size_t     __LIB__ __CALLEE__    w_vector_erase_range_callee(w_vector_t *v, size_t idx_first, size_t idx_last);
extern w_vector_t __LIB__ __CALLEE__   *w_vector_init_callee(void *p, size_t capacity, size_t max_size);
extern size_t     __LIB__ __CALLEE__    w_vector_insert_callee(w_vector_t *v, size_t idx, void *item);
extern size_t     __LIB__ __CALLEE__    w_vector_insert_n_callee(w_vector_t *v, size_t idx, size_t n, void *item);
extern size_t     __LIB__ __CALLEE__    w_vector_push_back_callee(w_vector_t *v, void *item);
extern int        __LIB__ __CALLEE__    w_vector_reserve_callee(w_vector_t *v, size_t n);
extern int        __LIB__ __CALLEE__    w_vector_resize_callee(w_vector_t *v, size_t n);

// wa_priority_queue

extern int                 __LIB__ __CALLEE__    wa_priority_queue_push_callee(wa_priority_queue_t *q, void *item);
extern int                 __LIB__ __CALLEE__    wa_priority_queue_resize_callee(wa_priority_queue_t *q, size_t n);

// wa_stack

extern wa_stack_t __LIB__ __CALLEE__   *wa_stack_init_callee(void *p, void *data, size_t capacity);
extern int        __LIB__ __CALLEE__    wa_stack_push_callee(wa_stack_t *s, void *item);

// wv_priority_queue

extern wv_priority_queue_t __LIB__ __CALLEE__   *wv_priority_queue_init_callee(void *p, size_t capacity, size_t max_size, void *compar);
extern int                 __LIB__ __CALLEE__    wv_priority_queue_push_callee(wv_priority_queue_t *q, void *item);
extern int                 __LIB__ __CALLEE__    wv_priority_queue_reserve_callee(wv_priority_queue_t *q, size_t n);
extern int                 __LIB__ __CALLEE__    wv_priority_queue_resize_callee(wv_priority_queue_t *q, size_t n);

// wv_stack

extern wv_stack_t __LIB__ __CALLEE__   *wv_stack_init_callee(void *p, size_t capacity, size_t max_size);
extern int        __LIB__ __CALLEE__    wv_stack_push_callee(wv_stack_t *s, void *item);
extern int        __LIB__ __CALLEE__    wv_stack_reserve_callee(wv_stack_t *s, size_t n);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

// b_array

#define b_array_append(a,b)                      b_array_append_callee(a,b);
#define b_array_append_block(a,b)                b_array_append_block_callee(a,b)
#define b_array_append_n(a,b,c)                  b_array_append_n_callee(b_array_t *a, size_t n, int c);
#define b_array_at(a,b)                          b_array_at_callee(b_array_t *a, size_t idx);
#define b_array_erase(a,b)                       b_array_erase_callee(b_array_t *a, size_t idx);
#define b_array_erase_range(a,b,c)               b_array_erase_range_callee(b_array_t *a, size_t idx_first, size_t idx_last);
#define b_array_init(a,b,c)                      b_array_init_callee(void *p, void *data, size_t capacity);
#define b_array_insert(a,b,c)                    b_array_insert_callee(b_array_t *a, size_t idx, int c);
#define b_array_insert_block(a,b,c)              b_array_insert_block_callee(b_array_t *a, size_t idx, size_t n);
#define b_array_insert_n(a,b,c,d)                b_array_insert_n_callee(b_array_t *a, size_t idx, size_t n, int c);
#define b_array_push_back(a,b)                   b_array_push_back_callee(b_array_t *a, int c);
#define b_array_read_block(a,b,c,d)              b_array_read_block_callee(void *dst, size_t n, b_array_t *a, size_t idx);
#define b_array_resize(a,b)                      b_array_resize_callee(b_array_t *a, size_t n);
#define b_array_write_block(a,b,c,d)             b_array_write_block_callee(void *src, size_t n, b_array_t *a, size_t idx);

// b_vector

#define b_vector_append(a,b)                     b_vector_append_callee(a,b)
#define b_vector_append_block(a,b)               b_vector_append_block_callee(a,b)
#define bvector_append_n(a,b,c)                  b_vector_append_n_callee(a,b,c)
#define b_vector_at(a,b)                         b_vector_at_callee(a,b)
#define b_vector_erase(a,b)                      b_vector_erase_callee(a,b)
#define b_vector_erase_block(a,b,c)              b_vector_erase_block_callee(a,b,c)
#define b_vector_erase_range(a,b,c)              b_vector_erase_range_callee(a,b,c)
#define b_vector_init(a,b,c)                     b_vector_init_callee(a,b,c)
#define b_vector_insert(a,b,c)                   b_vector_insert_callee(a,b,c)
#define b_vector_insert_block(a,b,c)             b_vector_insert_block_callee(a,b,c)
#define b_vector_insert_n(a,b,c,d)               b_vector_insert_n_callee(a,b,c,d)
#define b_vector_push_back(a,b)                  b_vector_push_back_callee(a,b)
#define b_vector_read_block(a,b,c,d)             b_vector_read_block_callee(a,b,c,d)
#define b_vector_reserve(a,b)                    b_vector_reserve_callee(a,b)
#define b_vector_resize(a,b)                     b_vector_resize_callee(a,b)
#define b_vector_write_block(a,b,c,d)            b_vector_write_block_callee(a,b,c,d)

// ba_priority_queue

#define ba_priority_queue_init(a,b,c,d)          ba_priority_queue_init_callee(a,b,c,d)
#define ba_priority_queue_push(a,b)              ba_priority_queue_push_callee(a,b)
#define ba_priority_queue_resize(a,b)            ba_priority_queue_resize_callee(a,b)

// ba_stack

#define ba_stack_init(a,b,c)                     ba_stack_init_callee(a,b,c)
#define ba_stack_push(a,b)                       ba_stack_push_callee(a,b)

// bv_priority_queue

#define bv_priority_queue_init(a,b,c,d)          bv_priority_queue_init_callee(a,b,c,d)
#define bv_priority_queue_push(a,b)              bv_priority_queue_push_callee(a,b)
#define bv_priority_queue_reserve(a,b)           bv_priority_queue_reserve_callee(a,b)
#define bv_priority_queue_resize(a,b)            bv_priority_queue_resize_callee(a,b)

// bv_stack

#define bv_stack_init(a,b,c)                     bv_stack_init_callee(a,b,c)
#define bv_stack_push(a,b)                       bv_stack_push_callee(a,b)
#define bv_stack_reserve(a,b)                    bv_stack_reserve_callee(a,b)

// p_forward_list

#define p_forward_list_insert_after(a,b)         p_forward_list_insert_after_callee(a,b)
#define p_forward_list_push_back(a,b)            p_forward_list_push_back_callee(a,b)
#define p_forward_list_push_front(a,b)           p_forward_list_push_front_callee(a,b)
#define p_forward_list_remove(a,b)               p_forward_list_remove_callee(a,b)

// p_forward_list_alt

#define p_forward_list_alt_insert_after(a,b,c)   p_forward_list_alt_insert_after_callee(a,b,c)
#define p_forward_list_alt_push_back(a,b)        p_forward_list_alt_push_back_callee(a,b)
#define p_forward_list_alt_push_front(a,b)       p_forward_list_alt_push_front_callee(a,b)
#define p_forward_list_alt_remove(a,b)           p_forward_list_alt_remove_callee(a,b)
#define p_forward_list_alt_remove_after(a,b)     p_forward_list_alt_remove_after_callee(a,b)

// p_list

#define p_list_insert(a,b,c)                     p_list_insert_callee(a,b,c)
#define p_list_insert_after(a,b,c)               p_list_insert_after_callee(a,b,c)
#define p_list_push_back(a,b)                    p_list_push_back_callee(a,b)
#define p_list_push_front(a,b)                   p_list_push_front_callee(a,b)
#define p_list_remove(a,b)                       p_list_remove_callee(a,b)
#define p_list_remove_after(a,b)                 p_list_remove_after_callee(a,b)

// p_queue

#define p_queue_push(a,b)                        p_queue_push_callee(a,b)

// p_stack

#define p_stack_push(a,b)                        p_stack_push_callee(a,b)

// w_array

#define w_array_append(a,b)                      w_array_append_callee(a,b)
#define w_array_append_n(a,b,c)                  w_array_append_n_callee(a,b,c)
#define w_array_at(a,b)                          w_array_at_callee(a,b)
#define w_array_erase(a,b)                       w_array_erase_callee(a,b)
#define w_array_erase_range(a,b,c)               w_array_erase_range_callee(a,b,c)
#define w_array_init(a,b,c)                      w_array_init_callee(a,b,c)
#define w_array_insert(a,b,c)                    w_array_insert_callee(a,b,c)
#define w_array_insert_n(a,b,c,d)                w_array_insert_n_callee(a,b,c,d)
#define w_array_push_back(a,b)                   w_array_push_back_callee(a,b)
#define w_array_resize(a,b)                      w_array_resize_callee(a,b)

// w_vector

#define w_vector_append(a,b)                     w_vector_append_callee(a,b)
#define w_vector_append_n(a,b,c)                 w_vector_append_n_callee(a,b,c)
#define w_vector_at(a,b)                         w_vector_at_callee(a,b)
#define w_vector_erase(a,b)                      w_vector_erase_callee(a,b)
#define w_vector_erase_range(a,b,c)              w_vector_erase_range_callee(a,b,c)
#define w_vector_init(a,b,c)                     w_vector_init_callee(a,b,c)
#define w_vector_insert(a,b,c)                   w_vector_insert_callee(a,b,c)
#define w_vector_insert_n(a,b,c,d)               w_vector_insert_n_callee(a,b,c,d)
#define w_vector_push_back(a,b)                  w_vector_push_back_callee(a,b)
#define w_vector_reserve(a,b)                    w_vector_reserve_callee(a,b)
#define w_vector_resize(a,b)                     w_vector_resize_callee(a,b)

// wa_priority_queue

#define wa_priority_queue_push(a,b)              wa_priority_queue_push_callee(a,b)
#define wa_priority_queue_resize(a,b)            wa_priority_queue_resize_callee(a,b)

// wa_stack

#define wa_stack_init(a,b,c)                     wa_stack_init_callee(a,b,c)
#define wa_stack_push(a,b)                       wa_stack_push_callee(a,b)

// wv_priority_queue

#define wv_priority_queue_init(a,b,c,d)          wv_priority_queue_init_callee(a,b,c,d)
#define wv_priority_queue_push(a,b)              wv_priority_queue_push_callee(a,b)
#define wv_priority_queue_reserve(a,b)           wv_priority_queue_reserve_callee(a,b)
#define wv_priority_queue_resize(a,b)            wv_priority_queue_resize_callee(a,b)

// wv_stack

#define wv_stack_init(a,b,c)                     wv_stack_init_callee(a,b,c)
#define wv_stack_push(a,b)                       wv_stack_push_callee(a,b)
#define wv_stack_reserve(a,b)                    wv_stack_reserve_callee(a,b)

#endif
