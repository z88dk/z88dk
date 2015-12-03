
; double frexp(double value, int *exp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_frexp

EXTERN cm48_sccz80p_dload, am48_frexp

cm48_sccz80_frexp:

   pop af
   pop hl
   
   push hl
   push af
   
   exx
   
   ld hl,4
   call cm48_sccz80p_dload
   
   jp am48_frexp
