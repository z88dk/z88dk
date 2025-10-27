
; void p_queue_clear_fastcall(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_clear_fastcall

EXTERN asm_p_queue_clear

defc _p_queue_clear_fastcall = asm_p_queue_clear
