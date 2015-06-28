
; double ldexp(double x, int exp)

SECTION code_fp_math48

PUBLIC cm48_sccz80_ldexp

EXTERN am48_ldexp, am48_dloadb

cm48_sccz80_ldexp:

   pop af
   pop hl                      ; hl = exp
   
   push hl
   push af
   
   exx
   
   ld hl,9
   add hl,sp
   
   call am48_dloadb

   jp am48_ldexp
