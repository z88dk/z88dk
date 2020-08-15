
SECTION code_fp_am9511

PUBLIC __moduint

EXTERN cam32_sdcc_imodu

   ; modulus of two 16-bit numbers into a 16-bit remainder
   ;
   ; enter : stack = dividend (16-bit), divisor (16-bit), ret
   ;
   ; exit  : dehl = remainder

defc __moduint = cam32_sdcc_imodu
