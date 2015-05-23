
; double __CALLEE__ frexp(double value, int *exp)

SECTION code_fp_math48

PUBLIC cm48_sccz80_frexp

EXTERN lm48_frexp

cm48_sccz80_frexp:

   pop af
   
   pop hl                      ; AC'= value
   pop de
   pop bc
   
   exx
   
   pop hl                      ; hl = exp
   
   push af
   
   jp lm48_frexp
