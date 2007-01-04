; void *HeapCalloc(void *heap, unsigned int nobj, unsigned int size)
; 12.2006 aralbrec

XLIB HeapCalloc
XDEF ASMDISP_HEAPCALLOC

LIB l_mult, HeapAlloc
XREF ASMDISP_HEAPALLOC

.HeapCalloc

   pop af
   pop de
   pop hl
   pop bc
   push bc
   push hl
   push de
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
   call HeapAlloc + ASMDISP_HEAPALLOC
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

DEFC ASMDISP_HEAPCALLOC = asmentry - HeapCalloc
