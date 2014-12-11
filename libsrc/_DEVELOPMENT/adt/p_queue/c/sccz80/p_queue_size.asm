
; size_t p_queue_size(p_queue_t *q)

SECTION code_adt_p_queue

PUBLIC p_queue_size

defc p_queue_size = asm_p_queue_size

INCLUDE "adt/p_queue/z80/asm_p_queue_size.asm"
