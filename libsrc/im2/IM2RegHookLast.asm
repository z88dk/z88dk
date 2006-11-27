; 04.2004 aralbrec

XLIB IM2RegHookLast
XREF _im2_hookDisp

; DISABLE INTERRUPTS PRIOR TO CALLING

; For use with the generic ISR only.  Installs a hook at the end
; of the list of registered hooks for a particular generic ISR
; installed on the vector passed in.
;
; enter: DE = address of hook (subroutine)
;         L = interrupt vector where Generic ISR is installed
; used : AF,BC,HL

.IM2RegHookLast
   ld a,i
   ld h,a
   ld c,(hl)
   inc hl
   ld b,(hl)
   ld hl,_im2_hookDisp - 1
   add hl,bc            ; hl points at hooks list-1

.loop
   inc hl
   ld a,(hl)
   inc hl
   or (hl)
   jp nz, loop

   ld (hl),d            ; found empty slot
   dec hl
   ld (hl),e
   ret
