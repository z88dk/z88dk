; void __CALLEE__ sp1_ChangeSprType_callee(struct sp1_cs *c, void *drawf)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ChangeSprType_callee

EXTERN asm_sp1_ChangeSprType

sp1_ChangeSprType_callee:

   pop hl
   pop de
   ex (sp),hl

;   jp asm_sp1_ChangeSprType
   push ix
   call asm_sp1_ChangeSprType
   pop ix
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_ChangeSprType_callee
defc _sp1_ChangeSprType_callee = sp1_ChangeSprType_callee
ENDIF

