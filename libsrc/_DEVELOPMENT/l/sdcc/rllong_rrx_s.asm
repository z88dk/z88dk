
PUBLIC __rlslong_rrx_s
PUBLIC __rlulong_rrx_s

EXTERN l_lsl_dehl

__rlslong_rrx_s:
__rlulong_rrx_s:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld a,c
   jp l_lsl_dehl
