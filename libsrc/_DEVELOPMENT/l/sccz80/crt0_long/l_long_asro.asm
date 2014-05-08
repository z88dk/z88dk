
PUBLIC l_long_asro

EXTERN l_asr_dehl

l_long_asro:

   ; dehl = 32-bit signed long
   ;    c = shift amount
   
   ld a,c
   jp l_asr_dehl
