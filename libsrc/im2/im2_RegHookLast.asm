; 05.2005 aralbrec

XLIB im2_RegHookLast
LIB IM2RegHookLast

.im2_RegHookLast
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld l,(hl)
   jp IM2RegHookLast

; enter: DE = address of hook (subroutine)
;         L = interrupt vector where Generic ISR is installed
; used : AF,BC,HL
