
; void p_queue_init(void *p)

PUBLIC _p_queue_init

EXTERN _p_forward_list_alt_init

_p_queue_init:

   jp _p_forward_list_alt_init

   INCLUDE "adt/p_queue/z80/asm_p_queue_init.asm"
