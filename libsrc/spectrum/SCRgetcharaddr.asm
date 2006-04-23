; 04.2006 aralbrec

XLIB SCRgetcharaddr

.SCRgetcharaddr

; Computes the screen address of the top of a character square.
; (0,0) is located at the top left corner of the screen.
;
; enter: h = y coord 0..23, l = x coord 0..31
; exit : hl = screen address
; uses : af,hl

   ld a,h
   rrca
   rrca
   rrca
   and $e0
   or l
   ld l,a
   ld a,h
   and $18
   or $40
   ld h,a
   ret
