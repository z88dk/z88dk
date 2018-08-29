; unsigned char esx_ide_get_lfn(struct esx_lfn *dir, struct esx_cat_entry *query)

SECTION code_esxdos

PUBLIC esx_ide_get_lfn

EXTERN asm_esx_ide_get_lfn

esx_ide_get_lfn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_esx_ide_get_lfn
