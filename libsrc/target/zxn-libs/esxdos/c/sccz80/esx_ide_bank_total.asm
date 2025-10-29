; unsigned char esx_ide_bank_total(unsigned char banktype)

SECTION code_esxdos

PUBLIC esx_ide_bank_total

EXTERN asm_esx_ide_bank_total

defc esx_ide_bank_total = asm_esx_ide_bank_total
