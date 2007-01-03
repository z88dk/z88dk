; void outp(uint port, uchar byte)
; 09.2005 aralbrec

XLIB outp
XDEF ASMDISP_OUTP

.outp

   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   
.asmentry

   out (c),a
   ret

DEFC ASMDISP_OUTP = asmentry - outp
