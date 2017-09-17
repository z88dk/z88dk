; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _wv_priority_queue_init_callee_sdcc
GLOBAL _wv_priority_queue_init_callee
GLOBAL wv_priority_queue_init_callee

defc _wv_priority_queue_init_callee = wv_priority_queue_init_callee

