; unsigned char esx_ide_mode_get(struct esx_mode *mode)

SECTION code_esxdos

PUBLIC esx_ide_mode_get

EXTERN asm_esx_ide_mode_get

defc esx_ide_mode_get = asm_esx_ide_mode_get
