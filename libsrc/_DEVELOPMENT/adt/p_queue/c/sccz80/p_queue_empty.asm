
; int p_queue_empty(p_queue_t *q)

SECTION code_adt_p_queue

PUBLIC p_queue_empty

defc p_queue_empty = asm_p_queue_empty

INCLUDE "adt/p_queue/z80/asm_p_queue_empty.asm"
