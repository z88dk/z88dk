
SECTION code_fp_am9511

PUBLIC __modslong_callee

EXTERN cam32_sdcc_lmods_callee

   ; modulus of two 32-bit numbers into a 32-bit remainder
   ;
   ; enter : stack = dividend (32-bit), divisor (32-bit), ret
   ;
   ; exit  : dehl = remainder

defc __modslong_callee = cam32_sdcc_lmods_callee
