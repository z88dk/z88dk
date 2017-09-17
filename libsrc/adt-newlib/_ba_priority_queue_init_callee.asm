; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _ba_priority_queue_init_callee_sdcc
GLOBAL _ba_priority_queue_init_callee
GLOBAL ba_priority_queue_init_callee

defc _ba_priority_queue_init_callee = ba_priority_queue_init_callee

