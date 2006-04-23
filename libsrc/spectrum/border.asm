; 04.2006 aralbrec

; void border(uchar colour)

XLIB border

.border

   ld hl,2
   add hl,sp
   ld a,(hl)
   out (254),a
   ret
