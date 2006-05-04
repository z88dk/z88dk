; 04.2006 aralbrec

XLIB ATTRgetcharaddr

.ATTRgetcharaddr

; Computes the attribute address given a valid character coordinate.
; (0,0) is located at the top left corner of the screen.
;
; enter :  h = y coord (0..23)
;          l = x coord (0..31)
; exit  : hl = attribute address
; uses  : af, hl

   xor a
   srl h
   rra
   srl h
   rra
   srl h
   rra
   or l
   ld l,a
   ld a,$58
   or h
   ld h,a
   ret
