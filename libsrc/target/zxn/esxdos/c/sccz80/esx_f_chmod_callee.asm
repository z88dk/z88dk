; unsigned char esx_f_chmod(unsigned char *filename, uint8_t attr_mask, uint8_t attr)

SECTION code_esxdos

PUBLIC esx_f_chmod_callee

EXTERN asm_esx_f_chmod

esx_f_chmod_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   ld b,e
   jp asm_esx_f_chmod

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_chmod_callee
defc _esx_f_chmod_callee = esx_f_chmod_callee
ENDIF

