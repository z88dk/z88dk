
XLIB __rrulong_rrx_s

LIB l_lsr_dehl

__rrulong_rrx_s:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld a,c
   jp l_lsr_dehl
