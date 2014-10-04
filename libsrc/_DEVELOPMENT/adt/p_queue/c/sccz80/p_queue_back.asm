
; void *p_queue_back(p_queue_t *q)

SECTION seg_code_p_queue

PUBLIC p_queue_back

defc p_queue_back = asm_p_queue_back

INCLUDE "adt/p_queue/z80/asm_p_queue_back.asm"
