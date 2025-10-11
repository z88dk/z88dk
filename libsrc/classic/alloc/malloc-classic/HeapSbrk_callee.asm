; void __CALLEE__ HeapSbrk_callee(void *heap, void *addr, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapSbrk_callee
PUBLIC _HeapSbrk_callee
PUBLIC asm_HeapSbrk

EXTERN asm_HeapFree

.HeapSbrk_callee
._HeapSbrk_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

.asm_HeapSbrk

; Add a block of memory to the specified heap.  The
; block must be at least 4 bytes in size.  Adding a
; block that overlaps with one already in the heap
; will wreck the heap.
;
; enter : de = heap pointer
;         hl = address of available block
;         bc = size of block in bytes >= 4
; exit  : block not added if too small
; uses  : af, bc, de, hl

.MAHeapSbrk

   ld a,b
   or a
   jr nz, sizeok
   ld a,c
   sub 4
   ret c
   
.sizeok

   dec bc
   dec bc
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   jp asm_HeapFree

