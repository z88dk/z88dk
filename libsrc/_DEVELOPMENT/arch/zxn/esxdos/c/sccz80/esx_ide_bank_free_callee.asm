; unsigned char esx_ide_bank_free(unsigned char banktype, unsigned char page)

SECTION code_esxdos

PUBLIC esx_ide_bank_free_callee

EXTERN asm_esx_ide_bank_free

esx_ide_bank_free_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld h,e
   jp asm_esx_ide_bank_free
