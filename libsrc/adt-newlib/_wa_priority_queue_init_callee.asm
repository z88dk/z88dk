; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _wa_priority_queue_init_callee_sdcc
GLOBAL _wa_priority_queue_init_callee
GLOBAL wa_priority_queue_init_callee

defc _wa_priority_queue_init_callee = wa_priority_queue_init_callee

