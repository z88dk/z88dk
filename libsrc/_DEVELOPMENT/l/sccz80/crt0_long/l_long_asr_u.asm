
PUBLIC l_long_asr_u

EXTERN l_lsr_dehl

l_long_asr_u:

   ;     l = shift amount
   ; stack = dehl, ret

   pop af
   pop hl
   pop de
   push af
   
   ld a,l
   jp l_lsr_dehl
     