
SECTION code_fp_am9511

PUBLIC __divslong_callee

EXTERN cam32_sdcc_ldivs_callee

   ; divide two 32-bit numbers into a 32-bit quotient
   ;
   ; enter : stack = dividend (32-bit), divisor (32-bit), ret
   ;
   ; exit  : dehl = quotient

defc __divslong_callee = cam32_sdcc_ldivs_callee
