; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _wv_priority_queue_init_sdcc
GLOBAL _wv_priority_queue_init
GLOBAL wv_priority_queue_init

defc _wv_priority_queue_init = wv_priority_queue_init

