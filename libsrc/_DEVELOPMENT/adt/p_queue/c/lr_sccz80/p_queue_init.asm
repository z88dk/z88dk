
; void p_queue_init(void *p)

XDEF p_queue_init

;defc p_queue_init = asm_p_queue_init

p_queue_init:

   INCLUDE "adt/p_queue/z80/asm_p_queue_init.asm"
