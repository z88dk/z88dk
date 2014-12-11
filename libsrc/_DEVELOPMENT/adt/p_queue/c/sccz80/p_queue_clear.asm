
; void p_queue_clear(p_queue_t *q)

SECTION code_adt_p_queue

PUBLIC p_queue_clear

defc p_queue_clear = asm_p_queue_clear

INCLUDE "adt/p_queue/z80/asm_p_queue_clear.asm"
