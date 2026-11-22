
; double scalbn(double x, int n)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_scalbn

EXTERN am48_scalbn, cm48_sccz80p_dload

cm48_sccz80_scalbn:

   pop af
   pop hl
   
   push hl
   push af
   
   exx
   
   ld hl,4
   add hl,sp
   
   call cm48_sccz80p_dload
   
   jp am48_scalbn
