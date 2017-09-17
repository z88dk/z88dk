; wa_priority_queue_t *
; wa_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_string

MODULE _wa_priority_queue_init_sdcc
GLOBAL _wa_priority_queue_init
GLOBAL wa_priority_queue_init

defc _wa_priority_queue_init = wa_priority_queue_init

