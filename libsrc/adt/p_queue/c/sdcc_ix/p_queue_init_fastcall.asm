
; void p_queue_init_fastcall(void *p)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_init_fastcall

EXTERN asm_p_queue_init

defc _p_queue_init_fastcall = asm_p_queue_init
