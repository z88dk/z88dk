
; int p_queue_empty(p_queue_t *q)

XDEF p_queue_empty

LIB p_forward_list_empty

defc p_queue_empty = p_forward_list_empty

INCLUDE "adt/p_queue/z80/asm_p_queue_empty.asm"
