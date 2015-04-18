
; void p_queue_init_fastcall(void *p)

SECTION code_adt_p_queue

PUBLIC _p_queue_init_fastcall

defc _p_queue_init_fastcall = asm_p_queue_init

INCLUDE "adt/p_queue/z80/asm_p_queue_init.asm"
