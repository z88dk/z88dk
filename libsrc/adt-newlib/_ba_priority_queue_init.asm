; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _ba_priority_queue_init_sdcc
GLOBAL _ba_priority_queue_init
GLOBAL ba_priority_queue_init

defc _ba_priority_queue_init = ba_priority_queue_init

