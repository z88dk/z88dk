; HeapCalloc
; 12.2006 aralbrec

XLIB MAHeapCalloc
LIB l_mult, MAHeapAlloc

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
   call MAHeapAlloc
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
