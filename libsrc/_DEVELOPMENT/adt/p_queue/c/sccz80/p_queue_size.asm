
; size_t p_queue_size(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_size

EXTERN asm_p_queue_size

defc p_queue_size = asm_p_queue_size

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_queue_size
defc _p_queue_size = p_queue_size
ENDIF

