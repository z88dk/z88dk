
; void *p_queue_back(p_queue_t *q)

SECTION seg_code_p_queue

PUBLIC _p_queue_back

EXTERN _p_forward_list_alt_back

defc _p_queue_back = _p_forward_list_alt_back

INCLUDE "adt/p_queue/z80/asm_p_queue_back.asm"
