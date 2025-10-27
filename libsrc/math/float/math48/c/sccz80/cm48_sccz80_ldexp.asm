
; double ldexp(double x, int exp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_ldexp

EXTERN am48_ldexp, cm48_sccz80p_dload

cm48_sccz80_ldexp:

   pop af
   pop hl                      ; hl = exp
   
   push hl
   push af
   
   exx
   
   ld hl,4
   add hl,sp
   
   call cm48_sccz80p_dload     ; AC'= x

   jp am48_ldexp
