
; int bv_priority_queue_resize(bv_priority_queue_t *q, size_t n)

SECTION seg_code_bv_priority_queue

PUBLIC _bv_priority_queue_resize

EXTERN _ba_priority_queue_resize

defc _bv_priority_queue_resize = _ba_priority_queue_resize

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_resize.asm"
