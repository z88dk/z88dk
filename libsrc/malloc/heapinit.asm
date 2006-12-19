; void __FASTCALL__ HeapInit(void *heap)
; 12.2006 aralbrec

XLIB HeapInit

; Just zero heap pointer to indicate empty heap.
;
; enter : hl = heap pointer
; uses  : hl

.HeapInit

   ld (hl),0
   inc hl
   ld (hl),0
   ret
