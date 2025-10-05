; unsigned char esx_ide_bank_free(unsigned char banktype, unsigned char page)

SECTION code_esxdos

PUBLIC _esx_ide_bank_free

EXTERN l0_esx_ide_bank_free_callee

_esx_ide_bank_free:

   pop af
   pop hl
   
   push hl
   push af
   
   jp l0_esx_ide_bank_free_callee
