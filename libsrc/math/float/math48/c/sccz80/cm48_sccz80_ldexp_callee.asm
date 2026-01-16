
; double __CALLEE__ ldexp(double x, int exp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_ldexp_callee

EXTERN cm48_sccz80p_dcallee1, am48_ldexp

cm48_sccz80_ldexp_callee:

   pop af
   pop hl                      ; hl = exp
   push af
   
   call cm48_sccz80p_dcallee1  ; AC'= x
   
   jp am48_ldexp
