
; double fma(double x, double y, double z)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_fma

EXTERN am48_fma, cm48_sccz80p_dread1, cm48_sccz80p_dload

cm48_sccz80_fma:

   ; stack = x (sccz80), y (sccz80), z (sccz80), ret

   call cm48_sccz80p_dread1
   exx
   
   ; AC = z (math48)
   ; stack = x (sccz80), y (sccz80), z (sccz80), ret
   
   pop af
   
   push bc
   push de
   push hl
   
   push af
   
   ; stack = x (sccz80), y (sccz80), z (sccz80), z (math48), ret

   ld hl,20
   add hl,sp                   ; hl = &x
   
   call cm48_sccz80p_dload
   
   ld hl,14                    ; hl = &y
   add hl,sp
   
   call cm48_sccz80p_dload
   
   ; AC = x (math48)
   ; AC'= y (math48)
   ; stack = x (sccz80), y (sccz80), z (sccz80), z (math48), ret

   jp am48_fma
