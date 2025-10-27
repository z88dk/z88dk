; struct sp1_update __CALLEE__ *sp1_GetUpdateStruct_callee(uchar row, uchar col)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_GetUpdateStruct_callee

EXTERN asm_sp1_GetUpdateStruct

sp1_GetUpdateStruct_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

;   jp asm_sp1_GetUpdateStruct
   push ix
   call asm_sp1_GetUpdateStruct
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_GetUpdateStruct_callee
defc _sp1_GetUpdateStruct_callee = sp1_GetUpdateStruct_callee
ENDIF

