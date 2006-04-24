; 04.2006 aralbrec

; void __FASTCALL__ border(uchar colour)

XLIB border

.border
   ld a,l
   out (254),a
   ret
