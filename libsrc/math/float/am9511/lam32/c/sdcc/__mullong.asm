
SECTION code_fp_am9511

PUBLIC __mullong

EXTERN cam32_sdcc_lmul

   ; multiply two 32-bit multiplicands into a 32-bit product
   ;
   ; enter : stack = multiplicand (32-bit), multiplicand (32-bit), ret
   ;
   ; exit  : dehl = product

defc __mullong = cam32_sdcc_lmul
