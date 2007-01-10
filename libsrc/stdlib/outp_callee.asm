; void outp_callee(uint port, uchar byte)
; 09.2005 aralbrec

XLIB outp_callee
XDEF ASMDISP_OUTP_CALLEE

.outp_callee

   pop af
   pop de
   pop bc
   push af

.asmentry

   ; bc = port
   ; e = byte

   out (c),e
   ret

DEFC ASMDISP_OUTP_CALLEE = asmentry - outp_callee
