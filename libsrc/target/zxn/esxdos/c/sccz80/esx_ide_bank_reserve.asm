; unsigned char esx_ide_bank_reserve(unsigned char banktype,unsigned char page)

SECTION code_esxdos

PUBLIC esx_ide_bank_reserve

EXTERN asm_esx_ide_bank_reserve

esx_ide_bank_reserve:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   jp asm_esx_ide_bank_reserve
