
; void p_queue_push(p_queue_t *q, void *item)

SECTION seg_code_p_queue

PUBLIC _p_queue_push

EXTERN _p_forward_list_alt_push_back

defc _p_queue_push = _p_forward_list_alt_push_back

INCLUDE "adt/p_queue/z80/asm_p_queue_push.asm"
