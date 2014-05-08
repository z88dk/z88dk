
PUBLIC l_asr_u

EXTERN l_lsr_hl

l_asr_u:

   ; hl = hl >> de
   
   ex de,hl
   ld a,e
   
   jp l_lsr_hl
