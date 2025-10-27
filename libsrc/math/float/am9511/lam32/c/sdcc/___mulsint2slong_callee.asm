
SECTION code_clib
SECTION code_fp_am9511

PUBLIC ___mulsint2slong_callee

EXTERN cam32_sdcc___mulsint2slong_callee

   ; multiply two signed 16-bit multiplicands into a 32-bit product
   ;
   ; enter : stack = multiplicand (16-bit), multiplicand (16-bit), ret
   ;
   ; exit  : dehl = product

defc ___mulsint2slong_callee = cam32_sdcc___mulsint2slong_callee
