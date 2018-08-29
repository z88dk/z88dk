; unsigned char esx_dos_catalog(struct esx_cat *cat)

SECTION code_esxdos

PUBLIC esx_dos_catalog

EXTERN asm_esx_dos_catalog

defc esx_dos_catalog = asm_esx_dos_catalog
