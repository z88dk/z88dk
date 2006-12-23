; void __FASTCALL__ HeapCreate(void *heap)
; 12.2006 aralbrec

XLIB HeapCreate

; Just zero heap pointer to indicate empty heap.
;
; enter : hl = heap pointer
; uses  : hl

.HeapCreate

   ld (hl),0
   inc hl
   ld (hl),0
   inc hl
   ld (hl),0
   inc hl
   ld (hl),0
   ret
