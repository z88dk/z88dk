; void outp_callee(uint port, uchar byte)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC outp_callee
PUBLIC _outp_callee
PUBLIC asm_outp

.outp_callee
._outp_callee

   pop af
   pop de
   pop bc
   push af

.asm_outp

   ; bc = port
   ; e = byte

IF __CPU_R2KA__|__CPU_R3K__

   ld h,b
   ld l,c
   ld a,e
   defb 0d3h ; ioi
   ld (hl),a

ELSE

   out (c),e

ENDIF

   ret
