; unsigned char esx_ide_bank_reserve(unsigned char banktype,unsigned char page)

SECTION code_esxdos

PUBLIC _esx_ide_bank_reserve

EXTERN l0_esx_ide_bank_reserve_callee

_esx_ide_bank_reserve:

   pop af
   pop hl
   
   push hl
   push af
   
   jp l0_esx_ide_bank_reserve_callee
