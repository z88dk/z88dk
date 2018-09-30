; unsigned char esx_ide_bank_free(unsigned char banktype, unsigned char page)

SECTION code_esxdos

PUBLIC _esx_ide_bank_free_callee
PUBLIC l0_esx_ide_bank_free_callee

EXTERN asm_esx_ide_bank_free

_esx_ide_bank_free_callee:

   pop hl
   ex (sp),hl
   
l0_esx_ide_bank_free_callee:

   push ix
   push iy
   
   call asm_esx_ide_bank_free

   pop iy
   pop ix

   ret
