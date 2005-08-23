; 05.2005 aralbrec

XLIB im2_RegHookFirst
LIB IM2RegHookFirst

.im2_RegHookFirst
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld l,(hl)
   jp IM2RegHookFirst

; enter: DE = address of hook (subroutine)
;         L = interrupt vector where generic ISR is installed
; used : AF,BC,DE,HL
