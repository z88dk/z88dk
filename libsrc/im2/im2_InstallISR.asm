; 05.2005 aralbrec

XLIB im2_InstallISR
LIB IM2InstallISR

.im2_InstallISR
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld l,(hl)
   call IM2InstallISR
   ex de,hl
   ret

; enter:  L = vector to install on (even by convention)
;        DE = new ISR address
; exit : DE = old ISR address
; uses : AF,DE,HL
