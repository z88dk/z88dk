
; size_t p_queue_size(p_queue_t *q)

SECTION seg_code_p_queue

PUBLIC p_queue_size

defc p_queue_size = asm_p_queue_size

INCLUDE "adt/p_queue/z80/asm_p_queue_size.asm"
