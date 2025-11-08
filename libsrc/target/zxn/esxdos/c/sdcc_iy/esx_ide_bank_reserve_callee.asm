; unsigned char esx_ide_bank_reserve(unsigned char banktype,unsigned char page)

SECTION code_esxdos

PUBLIC _esx_ide_bank_reserve_callee
PUBLIC l0_esx_ide_bank_reserve_callee

EXTERN asm_esx_ide_bank_reserve

_esx_ide_bank_reserve_callee:

   pop hl
   ex (sp),hl

l0_esx_ide_bank_reserve_callee:

   push iy
   
   call asm_esx_ide_bank_reserve
   
   pop iy
   ret
