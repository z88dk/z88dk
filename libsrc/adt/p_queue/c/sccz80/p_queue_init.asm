
; void p_queue_init(void *p)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_init

EXTERN asm_p_queue_init

defc p_queue_init = asm_p_queue_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_queue_init
defc _p_queue_init = p_queue_init
ENDIF

