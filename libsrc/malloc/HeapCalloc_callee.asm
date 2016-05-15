; void __CALLEE__ *HeapCalloc_callee(void *heap, unsigned int nobj, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapCalloc_callee
PUBLIC _HeapCalloc_callee
PUBLIC ASMDISP_HEAPCALLOC_CALLEE

EXTERN l_mult, HeapAlloc_callee
EXTERN ASMDISP_HEAPALLOC_CALLEE

.HeapCalloc_callee
._HeapCalloc_callee

   pop af
   pop de
   pop hl
   pop bc
   push af

.asmentry

; Allocate memory from the indicated heap and clear it to zeroes
;
; enter : hl = number of objects
;         de = size of each object
;         bc = & heap pointer
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry if failed
; uses  : af, bc, de, hl

.MAHeapCalloc

   push bc
   call l_mult               ; hl = hl*de = total size of request
   ld c,l
   ld b,h
   pop hl
   push bc
   call HeapAlloc_callee + ASMDISP_HEAPALLOC_CALLEE
   pop bc
   ret nc                    ; ret if fail
   
   ld a,b
   or c
   jr z, out

   ld (hl),0
   dec bc
   ld a,b
   or c
   jr z, out
      
   push hl                   ; zero memory block
   ld e,l
   ld d,h
   inc de
   ldir
   pop hl
   
.out

   scf
   ret

DEFC ASMDISP_HEAPCALLOC_CALLEE = # asmentry - HeapCalloc_callee
