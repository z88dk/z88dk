; unsigned char esx_ide_bank_alloc(unsigned char banktype)

SECTION code_esxdos

PUBLIC _esx_ide_bank_alloc

EXTERN _esx_ide_bank_alloc_fastcall

_esx_ide_bank_alloc:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_ide_bank_alloc_fastcall
