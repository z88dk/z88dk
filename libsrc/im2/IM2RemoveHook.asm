; 04.2004 aralbrec

XLIB IM2RemoveHook
XREF _im2_hookDisp

; DISABLE INTERRUPTS PRIOR TO CALLING

; For use with the generic ISR only.  Removes a hook from the
; generic ISR installed on the vector specified.
;
; enter: DE = address of hook (subroutine)
;         L = interrupt vector where Generic ISR is installed
; used : AF,BC,DE,HL
; exit : carry = hook found and removed
;        no carry = hook not found

.IM2RemoveHook
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
