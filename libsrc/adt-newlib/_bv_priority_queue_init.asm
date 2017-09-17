; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _bv_priority_queue_init_sdcc
GLOBAL _bv_priority_queue_init
GLOBAL bv_priority_queue_init

defc _bv_priority_queue_init = bv_priority_queue_init

