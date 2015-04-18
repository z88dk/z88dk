
; void p_queue_clear_fastcall(p_queue_t *q)

SECTION code_adt_p_queue

PUBLIC _p_queue_clear_fastcall

defc _p_queue_clear_fastcall = asm_p_queue_clear

INCLUDE "adt/p_queue/z80/asm_p_queue_clear.asm"
