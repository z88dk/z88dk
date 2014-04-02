
; void p_queue_init(void *p)

XDEF _p_queue_init

LIB _p_forward_list_alt_init

_p_queue_init:

   jp _p_forward_list_alt_init

   INCLUDE "adt/p_queue/z80/asm_p_queue_init.asm"
