
; double __CALLEE__ ldexp(double x, int exp)

SECTION code_fp_math48

PUBLIC cm48_sccz80_ldexp

EXTERN lm48_ldexp

cm48_sccz80_ldexp:

   pop af
   
   pop hl                      ; hl = exp
   
   exx
   
   pop hl                      ; AC'= x
   pop de
   pop bc
   
   exx
   
   push af
   
   jp lm48_ldexp
