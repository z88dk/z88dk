
; void p_queue_init(void *p)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_init

EXTERN asm_p_queue_init

defc p_queue_init = asm_p_queue_init
