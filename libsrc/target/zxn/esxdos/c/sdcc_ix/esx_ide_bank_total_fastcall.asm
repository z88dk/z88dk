; unsigned char esx_ide_bank_total(unsigned char banktype)

SECTION code_esxdos

PUBLIC _esx_ide_bank_total_fastcall

EXTERN asm_esx_ide_bank_total

_esx_ide_bank_total_fastcall:

   push ix
   push iy
   
   call asm_esx_ide_bank_total
   
   pop iy
   pop ix

   ret
