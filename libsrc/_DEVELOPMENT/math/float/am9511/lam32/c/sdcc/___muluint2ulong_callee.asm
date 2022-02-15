
SECTION code_clib
SECTION code_fp_am9511

PUBLIC ___muluint2ulong_callee

EXTERN cam32_sdcc___muluint2ulong_callee

   ; multiply two unsigned 16-bit multiplicands into a 32-bit product
   ;
   ; enter : stack = multiplicand (16-bit), multiplicand (16-bit), ret
   ;
   ; exit  : dehl = product

defc ___muluint2ulong_callee = cam32_sdcc___muluint2ulong_callee
