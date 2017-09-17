; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

SECTION code_clib
SECTION code_string

MODULE _wv_priority_queue_push_callee_sdcc
GLOBAL _wv_priority_queue_push_callee
GLOBAL wv_priority_queue_push_callee

defc _wv_priority_queue_push_callee = wv_priority_queue_push_callee

