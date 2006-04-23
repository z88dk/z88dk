; 04.2006 aralbrec

XLIB SCRpixelleft

.SCRpixelleft

; Adjusts screen address HL and pixel mask B to move left
; one pixel on screen.
;
; enter: HL = valid screen address
;         B = pixel mask for screen byte
; exit : Carry = moved off screen
;        HL, B moved left one pixel
; used : AF, HL

   rlc b
   ret nc
   ld a,l
   dec l
   and $1f
   ret nz
   scf 
   ret
