; 04.2006 aralbrec

XLIB SCRpixelright

.SCRpixelright

; Adjusts screen address HL and pixel mask B to move right
; one pixel on screen.
;
; enter: HL = valid screen address
;         B = pixel mask for screen byte
; exit : Carry = moved off screen
;        HL, B moved right one pixel
; used : AF, HL

   rrc b
   ret nc
   inc l
   ld a,l
   and $1f
   ret nz
   scf 
   ret
