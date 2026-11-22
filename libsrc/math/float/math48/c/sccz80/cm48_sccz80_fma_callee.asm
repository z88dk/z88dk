
; double __CALLEE__ fma(double x, double y, double z)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_fma_callee

EXTERN am48_fma, cm48_sccz80p_dcallee2, cm48_sccz80p_dcallee1_0, asm0_memswap

cm48_sccz80_fma_callee:

   ; stack = x (sccz80), y (sccz80), z (sccz80), ret

   call cm48_sccz80p_dcallee1_0
   
   ; AC = z (math48)
   ; stack = x (sccz80), y (sccz80), ret

   pop af
   
   push bc
   push de
   push hl
   
   push af
   
   ld hl,2
   add hl,sp
   ex de,hl                    ; de = &z
   
   ld hl,14
   add hl,sp                   ; hl = &x
   
   ld bc,6
   call asm0_memswap

   ; stack = z (math48), y (sccz80), x (sccz80), ret

   call cm48_sccz80p_dcallee2
   exx
   
   ; AC = x (math48)
   ; AC'= y (math48)
   ; stack = z (math48), ret

   jp am48_fma
