; void __FASTCALL__ HeapCreate(void *heap)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapCreate
PUBLIC _HeapCreate
EXTERN l_setmem

; Just zero heap pointer to indicate empty heap.
;
; enter : hl = heap pointer
; uses  : af, hl

.HeapCreate
._HeapCreate

   xor a
   jp l_setmem - 7           ; four bytes: 2*4-1
