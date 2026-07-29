;
;  feilipu, 2020
;
;  Portable: significant digit counts for half-float formatting.
;

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f16_sigdig

.asm_f16_sigdig
   ; exit  : b = significant hex digits in half float representation
   ;         c = significant decimal digits in half float representation
   ;
   ; uses  : bc

   ld bc,$0304
   ret
