
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_sigdig

asm_am9511_sigdig:

   ; exit  : b = number of significant hex digits in double representation
   ;         c = number of significant decimal digits in double representation
   ;
   ; uses  : bc

   ld bc,$0607
   ret
