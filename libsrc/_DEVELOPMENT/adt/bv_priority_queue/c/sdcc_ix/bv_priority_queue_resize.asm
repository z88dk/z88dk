
; int bv_priority_queue_resize(bv_priority_queue_t *q, size_t n)

XDEF _bv_priority_queue_resize

LIB _ba_priority_queue_resize

_bv_priority_queue_resize:

   jp _ba_priority_queue_resize

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_resize.asm"
