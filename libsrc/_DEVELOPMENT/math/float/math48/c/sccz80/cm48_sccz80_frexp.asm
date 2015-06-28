
; double frexp(double value, int *exp)

SECTION code_fp_math48

PUBLIC cm48_sccz80_frexp

EXTERN am48_frexp, am48_dloadb

cm48_sccz80_frexp:

   pop af
   pop hl
   
   push hl
   push af
   
   exx
   
   ld hl,9
   call am48_dloadb
   
   jp am48_frexp
