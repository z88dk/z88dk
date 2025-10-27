; unsigned char esx_ide_bank_avail(unsigned char banktype)

SECTION code_esxdos

PUBLIC _esx_ide_bank_avail

EXTERN _esx_ide_bank_avail_fastcall

_esx_ide_bank_avail:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_ide_bank_avail_fastcall
