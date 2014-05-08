
PUBLIC l_long_asr_uo

EXTERN l_lsr_dehl

l_long_asr_uo:

   ; dehl = 32-bit unsigned long
   ;    c = shift amount
   
   ld a,c
   jp l_lsr_dehl
