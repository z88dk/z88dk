
XLIB l_long_asl

LIB l_lsl_dehl

l_long_asl:

   ;     l = shift amount
   ; stack = dehl, ret
   
   pop af
   pop hl
   pop de
   push af
   
   ld a,l
   jp l_lsl_dehl
