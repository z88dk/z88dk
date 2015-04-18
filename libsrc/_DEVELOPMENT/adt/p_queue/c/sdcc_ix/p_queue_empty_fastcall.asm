
; int p_queue_empty_fastcall(p_queue_t *q)

SECTION code_adt_p_queue

PUBLIC _p_queue_empty_fastcall

defc _p_queue_empty_fastcall = asm_p_queue_empty

INCLUDE "adt/p_queue/z80/asm_p_queue_empty.asm"
