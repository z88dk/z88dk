
; void p_queue_init(void *p)

XDEF p_queue_init

LIB p_forward_list_alt_init

defc p_queue_init = p_forward_list_alt_init

INCLUDE "adt/p_queue/z80/asm_p_queue_init.asm"
