; unsigned char esx_ide_bank_alloc(unsigned char banktype)

SECTION code_esxdos

PUBLIC esx_ide_bank_alloc

EXTERN asm_esx_ide_bank_alloc

defc esx_ide_bank_alloc = asm_esx_ide_bank_alloc
