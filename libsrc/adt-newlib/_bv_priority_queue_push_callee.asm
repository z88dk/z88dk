; int bv_priority_queue_push(bv_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_string

MODULE _bv_priority_queue_push_callee_sdcc
GLOBAL _bv_priority_queue_push_callee
GLOBAL bv_priority_queue_push_callee

defc _bv_priority_queue_push_callee = bv_priority_queue_push_callee

