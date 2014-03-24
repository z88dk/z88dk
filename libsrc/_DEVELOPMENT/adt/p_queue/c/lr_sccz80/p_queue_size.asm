
; size_t p_queue_size(p_queue_t *q)

XDEF p_queue_size

;defc p_queue_size = asm_p_queue_size

p_queue_size:

   INCLUDE "adt/p_queue/z80/asm_p_queue_size.asm"
