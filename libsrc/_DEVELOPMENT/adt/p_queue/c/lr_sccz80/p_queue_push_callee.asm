
; void p_queue_push(p_queue_t *q, void *item)

PUBLIC p_queue_push_callee

EXTERN p_forward_list_alt_push_back_callee

;defc p_queue_push_callee = p_forward_list_alt_push_back_callee

p_queue_push_callee:

   jp p_forward_list_alt_push_back_callee

INCLUDE "adt/p_queue/z80/asm_p_queue_push.asm"
