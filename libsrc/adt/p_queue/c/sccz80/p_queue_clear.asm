
; void p_queue_clear(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_clear

EXTERN asm_p_queue_clear

defc p_queue_clear = asm_p_queue_clear

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_queue_clear
defc _p_queue_clear = p_queue_clear
ENDIF

