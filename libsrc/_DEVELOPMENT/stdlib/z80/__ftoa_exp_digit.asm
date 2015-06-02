
SECTION code_stdlib

PUBLIC __ftoa_exp_digit

__ftoa_exp_digit:

   inc e
   sub d

   jr nc, __ftoa_exp_digit
   
   add a,d
   
   ld (hl),e
   inc hl
   
   ret
