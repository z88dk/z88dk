
; size_t p_queue_size(p_queue_t *q)

XDEF p_queue_size

LIB p_forward_list_size

p_queue_size:

   jp p_forward_list_size

   INCLUDE "adt/p_queue/z80/asm_p_queue_size.asm"
