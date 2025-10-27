; unsigned char esx_dos_get_drive(void)

SECTION code_esxdos

PUBLIC esx_dos_get_drive

EXTERN asm_esx_dos_get_drive

defc esx_dos_get_drive = asm_esx_dos_get_drive
