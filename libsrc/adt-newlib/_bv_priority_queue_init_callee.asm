; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _bv_priority_queue_init_callee_sdcc
GLOBAL _bv_priority_queue_init_callee
GLOBAL bv_priority_queue_init_callee

defc _bv_priority_queue_init_callee = bv_priority_queue_init_callee

