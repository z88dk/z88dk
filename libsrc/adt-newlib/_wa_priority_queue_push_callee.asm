; int wa_priority_queue_push(wa_priority_queue_t *q, void *item)

SECTION code_clib
SECTION code_string

MODULE _wa_priority_queue_push_callee_sdcc
GLOBAL _wa_priority_queue_push_callee
GLOBAL wa_priority_queue_push_callee

defc _wa_priority_queue_push_callee = wa_priority_queue_push_callee

