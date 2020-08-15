
SECTION code_fp_am9511

PUBLIC __divulong_callee

EXTERN cam32_sdcc_idivu_callee

   ; divide two 16-bit numbers into a 16-bit quotient
   ;
   ; enter : stack = dividend (16-bit), divisor (16-bit), ret
   ;
   ; exit  : dehl = quotient

defc __divulong_callee = cam32_sdcc_idivu_callee
