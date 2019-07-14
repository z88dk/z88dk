;
;       Small C+ Long Library Functions
;
;       Divide 2 32 bit numbers
;
;       Hopefully this routine does work!
;
;       I think the use of ix is unavoidable in this case..unless you know
;       otherwise!
;
;       Replaced use of ix with bcbc'

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_div

EXTERN l_divs_32_32x32

l_long_div:

   ; dehl  = divisor
   ; stack = dividend, ret
   
   exx
   pop bc

   pop hl
   pop de

   push bc
   exx
   
   jp l_divs_32_32x32
