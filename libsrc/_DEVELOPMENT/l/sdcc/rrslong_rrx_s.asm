
PUBLIC __rrslong_rrx_s

EXTERN l_asr_dehl

__rrslong_rrx_s:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld a,c
   jp l_asr_dehl
