;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

IF !__CPU_GBZ80__
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gintspsp

l_gintspsp:

   add hl,sp
   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ex (sp),hl
   jp (hl)
ENDIF
