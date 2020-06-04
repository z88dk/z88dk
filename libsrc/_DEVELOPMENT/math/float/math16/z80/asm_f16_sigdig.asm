
SECTION code_fp_math16

PUBLIC asm_f16_sigdig

asm_f16_sigdig:

   ; exit  : b = number of significant hex digits in half float representation
   ;         c = number of significant decimal digits in half float representation
   ;
   ; uses  : bc

   ld bc,$0304
   ret
