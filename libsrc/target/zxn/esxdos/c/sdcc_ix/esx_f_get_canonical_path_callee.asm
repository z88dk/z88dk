; unsigned char esx_f_get_canonical_path(char *pathname, char *canonical)

SECTION code_esxdos

PUBLIC _esx_f_get_canonical_path_callee
PUBLIC l_esx_f_get_canonical_path_callee

EXTERN asm_esx_f_get_canonical_path

_esx_f_get_canonical_path_callee:

   pop hl
   pop de
   ex (sp),hl

l_esx_f_get_canonical_path_callee:

   push ix
   push iy
   
   call asm_esx_f_get_canonical_path
   
   pop iy
   pop ix
   
   ret
