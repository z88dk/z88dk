
; double fma(double x, double y, double z)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fma

EXTERN am48_fma, am48_dloadb

cm48_sccz80_fma:

   ; stack = x, y, z, ret
   
   ld hl,7
   add hl,sp
   
   call am48_dloadb
   
   ; AC'= z
   
   ld hl,13
   add hl,sp
   
   call am48_dloadb
   
   ; AC = z
   ; AC'= y
   
   push bc
   push de
   push hl
   
   ld hl,25
   add hl,sp
   
   call am48_dloadb
   
   ; AC = y
   ; AC'= x
   ; stack = z
   
   call am48_fma
   ret
