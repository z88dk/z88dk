; void __FASTCALL__ HeapCreate(void *heap)
; 12.2006 aralbrec

XLIB HeapCreate

; Just zero heap pointer to indicate empty heap.
;
; enter : hl = heap pointer
; uses  : af, hl

.HeapCreate

   xor a
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   ret
