
; void p_queue_init(void *p)

XDEF p_queue_init

LIB p_forward_list_alt_init

p_queue_init:

   jp p_forward_list_alt_init

   INCLUDE "adt/p_queue/z80/asm_p_queue_init.asm"
