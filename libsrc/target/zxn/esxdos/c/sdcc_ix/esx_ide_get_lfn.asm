; unsigned char esx_ide_get_lfn(struct esx_lfn *dir, struct esx_cat_entry *query)

SECTION code_esxdos

PUBLIC _esx_ide_get_lfn

EXTERN l_esx_ide_get_lfn_callee

_esx_ide_get_lfn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l_esx_ide_get_lfn_callee
