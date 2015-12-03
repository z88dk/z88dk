
; double modf(double value, double *iptr)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_modf

EXTERN cm48_sccz80p_dload, l0_cm48_sccz80_modf_callee

cm48_sccz80_modf:

   pop af
   pop hl                      ; hl = iptr
   
   push hl
   push af
   
   exx
   
   ld hl,4
   add hl,sp
   
   call cm48_sccz80p_dload
   
   jp l0_cm48_sccz80_modf_callee
