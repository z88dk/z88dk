; unsigned char esx_dos_set_drive(unsigned char drive)

SECTION code_esxdos

PUBLIC esx_dos_set_drive

EXTERN asm_esx_dos_set_drive

defc esx_dos_set_drive = asm_esx_dos_set_drive
