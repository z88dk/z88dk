
SECTION code_fp_am9511

PUBLIC __modulong

EXTERN cam32_sdcc_lmodu

   ; modulus of two 32-bit numbers into a 32-bit remainder
   ;
   ; enter : stack = dividend (32-bit), divisor (32-bit), ret
   ;
   ; exit  : dehl = remainder

defc __modulong = cam32_sdcc_lmodu
