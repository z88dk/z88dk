
; size_t p_queue_size(p_queue_t *q)

XDEF p_queue_size

LIB p_forward_list_size

defc p_queue_size = p_forward_list_size

INCLUDE "../../z80/asm_p_queue_size.asm"
