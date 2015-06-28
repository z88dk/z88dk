
; double scalbn(double x, int n)

SECTION code_fp_math48

PUBLIC cm48_sccz80_scalbn

EXTERN am48_scalbn, am48_dloadb

cm48_sccz80_scalbn:

   pop af
   pop hl
   
   push hl
   push af
   
   exx
   
   ld hl,9
   add hl,sp
   
   call am48_dloadb
   
   jp am48_scalbn
