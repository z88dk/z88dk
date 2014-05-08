
PUBLIC l_asl

EXTERN l_lsl_hl

l_asl:

   ; hl = de << hl
   
   ex de,hl
   ld a,e
   
   jp l_lsl_hl
