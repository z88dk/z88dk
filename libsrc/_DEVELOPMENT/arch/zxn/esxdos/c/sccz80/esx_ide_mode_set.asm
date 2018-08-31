; unsigned char esx_ide_mode_set(struct esx_mode *mode)

SECTION code_esxdos

PUBLIC esx_ide_mode_set

EXTERN asm_esx_ide_mode_set

defc esx_ide_mode_set = asm_esx_ide_mode_set
