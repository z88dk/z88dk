
; double __CALLEE__ frexp(double value, int *exp)

SECTION code_fp_math48

PUBLIC cm48_sccz80_frexp

EXTERN am48_frexp

cm48_sccz80_frexp:

   pop af

   pop hl                      ; hl = exp
   
   exx

   pop hl                      ; AC'= value
   pop de
   pop bc
   
   exx
   
   push af
   
   jp am48_frexp
