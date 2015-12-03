
; int p_queue_empty(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_empty

EXTERN asm_p_queue_empty

defc p_queue_empty = asm_p_queue_empty
