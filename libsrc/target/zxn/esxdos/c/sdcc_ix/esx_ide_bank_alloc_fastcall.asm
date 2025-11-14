; unsigned char esx_ide_bank_alloc(unsigned char banktype)

SECTION code_esxdos

PUBLIC _esx_ide_bank_alloc_fastcall

EXTERN asm_esx_ide_bank_alloc

_esx_ide_bank_alloc_fastcall:

   push ix
   push iy
   
   call asm_esx_ide_bank_alloc
   
   pop iy
   pop ix

   ret
