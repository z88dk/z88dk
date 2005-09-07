; void outp(uint port, uchar byte)
; 09.2005 aralbrec

XLIB outp

.outp
   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   out (c),a
   ret
