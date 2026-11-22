; unsigned char esx_ide_bank_total(unsigned char banktype)

SECTION code_esxdos

PUBLIC _esx_ide_bank_total

EXTERN _esx_ide_bank_total_fastcall

_esx_ide_bank_total:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_ide_bank_total_fastcall
