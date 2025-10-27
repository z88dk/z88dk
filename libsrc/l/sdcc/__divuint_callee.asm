
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divuint_callee

EXTERN l_divu_16_16x16

__divuint_callee:

   ; unsigned 16-bit division
   ;
   ; enter : stack = divisor, dividend, ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder
   
   pop af
   pop hl                      ; hl = dividend
   pop de                      ; de = divisor
   push af
   
   jp l_divu_16_16x16
