; unsigned char esx_ide_bank_free(unsigned char banktype, unsigned char page)

SECTION code_esxdos

PUBLIC esx_ide_bank_free

EXTERN asm_esx_ide_bank_free

esx_ide_bank_free:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   jp asm_esx_ide_bank_free
