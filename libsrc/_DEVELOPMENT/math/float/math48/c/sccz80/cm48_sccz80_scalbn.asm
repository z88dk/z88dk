
; double __CALLEE__ scalbn(double x, int n)

SECTION code_fp_math48

PUBLIC cm48_sccz80_scalbn

EXTERN am48_scalbn

cm48_sccz80_scalbn:

   pop af
   
   pop hl                      ; hl = n
   
   exx
   
   pop hl                      ; AC'= x
   pop de
   pop bc
   
   exx
   
   push af
   
   jp am48_scalbn
