; unsigned char esx_ide_bank_avail(unsigned char banktype)

SECTION code_esxdos

PUBLIC _esx_ide_bank_avail_fastcall

EXTERN asm_esx_ide_bank_avail

_esx_ide_bank_avail_fastcall:

   push iy
   
   call asm_esx_ide_bank_avail
   
   pop iy
   ret
