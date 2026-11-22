
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_negate

mm48_negate:

   ; AC = -AC
   ;
   ; uses : af, b
   
   inc l
   dec l
   ret z                       ; if AC == 0
   
   ld a,$80
   xor b
   ld b,a
   
   ret
