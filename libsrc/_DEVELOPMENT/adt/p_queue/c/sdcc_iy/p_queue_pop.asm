
; void *p_queue_pop(p_queue_t *q)

SECTION seg_code_p_queue

PUBLIC _p_queue_pop

EXTERN _p_forward_list_alt_pop_front

defc _p_queue_pop = _p_forward_list_alt_pop_front

INCLUDE "adt/p_queue/z80/asm_p_queue_pop.asm"
