; 05.2005 aralbrec

XLIB im2_RemoveHook
LIB IM2RemoveHook

.im2_RemoveHook
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld l,(hl)
   call IM2RemoveHook
   ld hl,0
   ret nc
   inc l
   ret

; enter: DE = address of hook (subroutine)
;         L = interrupt vector where Generic ISR is installed
; used : AF,BC,DE,HL
; exit : carry = hook found and removed
;        no carry = hook not found
