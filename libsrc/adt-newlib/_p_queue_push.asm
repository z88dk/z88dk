; void p_queue_push(p_queue_t *q, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_queue_push_sdcc
GLOBAL _p_queue_push
GLOBAL p_queue_push

defc _p_queue_push = p_queue_push

