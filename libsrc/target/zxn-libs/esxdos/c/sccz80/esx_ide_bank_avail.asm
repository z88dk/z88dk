; unsigned char esx_ide_bank_avail(unsigned char banktype)

SECTION code_esxdos

PUBLIC esx_ide_bank_avail

EXTERN asm_esx_ide_bank_avail

defc esx_ide_bank_avail = asm_esx_ide_bank_avail
