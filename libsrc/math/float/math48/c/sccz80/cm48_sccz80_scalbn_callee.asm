
; double __CALLEE__ scalbn(double x, int n)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_scalbn_callee

EXTERN cm48_sccz80p_dcallee1, am48_scalbn

cm48_sccz80_scalbn_callee:

   pop af
   pop hl                      ; hl = n
   push af
   
   call cm48_sccz80p_dcallee1  ; AC'= x
   
   jp am48_scalbn
