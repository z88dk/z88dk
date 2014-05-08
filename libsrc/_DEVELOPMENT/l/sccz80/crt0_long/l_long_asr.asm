
PUBLIC l_long_asr

EXTERN l_asr_dehl

l_long_asr:

   ;     l = shift amount
   ; stack = dehl, ret

   pop af
   pop hl
   pop de
   push af
   
   ld a,l
   jp l_asr_dehl
