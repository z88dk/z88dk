
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_exp_digit

__dtoa_exp_digit:

   inc e
   sub d

   jr nc, __dtoa_exp_digit
   
   add a,d
   
   ld (hl),e
   inc hl
   
   ret
