; unsigned char esx_ide_get_lfn(struct esx_lfn *dir, struct esx_cat_entry *query)

SECTION code_esxdos

PUBLIC _esx_ide_get_lfn_callee
PUBLIC l_esx_ide_get_lfn_callee

EXTERN asm_esx_ide_get_lfn

_esx_ide_get_lfn_callee:

   pop af
   pop hl
   pop de
   push af

l_esx_ide_get_lfn_callee:

   push ix
   push iy
   
   call asm_esx_ide_get_lfn
   
   pop iy
   pop ix
   
   ret
