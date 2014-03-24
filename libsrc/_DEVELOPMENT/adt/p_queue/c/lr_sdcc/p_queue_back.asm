
; void *p_queue_back(p_queue_t *q)

XDEF p_queue_back

LIB p_forward_list_alt_back

defc p_queue_back = p_forward_list_alt_back

INCLUDE "adt/p_queue/z80/asm_p_queue_back.asm"
