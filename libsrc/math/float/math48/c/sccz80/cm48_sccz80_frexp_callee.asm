
; double __CALLEE__ frexp(double value, int *exp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_frexp_callee

EXTERN cm48_sccz80p_dcallee1, am48_frexp

cm48_sccz80_frexp_callee:

   pop af
   pop hl                      ; hl = *exp
   push af
   
   call cm48_sccz80p_dcallee1  ; AC'= value
   
   jp am48_frexp
