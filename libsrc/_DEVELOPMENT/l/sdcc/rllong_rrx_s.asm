
XLIB __rlslong_rrx_s
XDEF __rlulong_rrx_s

LIB l_lsl_dehl

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
