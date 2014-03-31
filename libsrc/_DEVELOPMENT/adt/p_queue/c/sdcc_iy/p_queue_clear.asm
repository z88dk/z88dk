
; void p_queue_clear(p_queue_t *q)

XDEF p_queue_clear

LIB p_forward_list_alt_init

p_queue_clear:

   jp p_forward_list_alt_init

   INCLUDE "adt/p_queue/z80/asm_p_queue_clear.asm"
