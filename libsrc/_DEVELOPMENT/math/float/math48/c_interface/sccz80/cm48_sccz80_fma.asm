
; double __CALLEE__ fma(double x, double y, double z)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fma

EXTERN lm48_fma, cm48_sccz80p_collect_2, asm0_memswap

cm48_sccz80_fma:

   ; swap x and z on stack
   
   ld hl,2
   add hl,sp
   ex de,hl                    ; de = &z
   
   ld hl,14
   add hl,sp                   ; hl = &x
   
   ld bc,6
   call asm0_memswap

   ; collect params

   call cm48_sccz80p_collect_2
   
   ; AC = x
   ; AC'= y
   ; stack = z, ret

   jp lm48_fma
