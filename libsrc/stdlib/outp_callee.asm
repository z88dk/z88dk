; void outp_callee(uint port, uchar byte)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC outp_callee
PUBLIC _outp_callee
PUBLIC ASMDISP_OUTP_CALLEE

.outp_callee
._outp_callee

   pop af
   pop de
   pop bc
   push af

.asmentry

   ; bc = port
   ; e = byte

IF FORrcmx000

   ld h,b
   ld l,c
   ld a,e
   defb 0d3h ; ioi
   ld (hl),a

ELSE

   out (c),e

ENDIF

   ret

DEFC ASMDISP_OUTP_CALLEE = # asmentry - outp_callee
