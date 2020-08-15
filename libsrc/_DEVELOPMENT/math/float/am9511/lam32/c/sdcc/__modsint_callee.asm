
SECTION code_fp_am9511

PUBLIC __modsint_callee

EXTERN cam32_sdcc_imods_callee

   ; modulus of two 16-bit numbers into a 16-bit remainder
   ;
   ; enter : stack = dividend (16-bit), divisor (16-bit), ret
   ;
   ; exit  : dehl = remainder

defc __modsint_callee = cam32_sdcc_imods_callee
