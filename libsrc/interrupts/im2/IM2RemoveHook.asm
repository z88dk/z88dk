
; 04.2004 aralbrec

SECTION code_clib
PUBLIC IM2RemoveHook
PUBLIC _IM2RemoveHook
EXTERN _im2_hookDisp

; enter: de = address of hook (subroutine)
;         l = interrupt vector where Generic ISR is installed
; used : af, bc, de, hl
; exit : carry = hook found and removed
;        no carry = hook not found

.IM2RemoveHook
._IM2RemoveHook

   ld a,i
   ld h,a
   ld c,(hl)
   inc hl
   ld b,(hl)
   ld hl,_im2_hookDisp - 1
   add hl,bc            ; hl points at hooks list-1

.search

   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)            ; bc = a hook address
   ld a,b
   or c
   ret z                ; ret nc, failed to find it
   ld a,c
   cp e
   jp nz, search
   ld a,b
   cp d
   jp nz, search

   ld e,l               ; found hook so remove it
   ld d,h
   dec de
   inc hl
   
.remove

   ld a,(hl)
   ldi
   or (hl)
   ldi
   jp nz, remove

   scf
   ret
