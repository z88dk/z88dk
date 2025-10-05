; unsigned char esx_f_get_canonical_path(char *pathname, char *canonical)

SECTION code_esxdos

PUBLIC esx_f_get_canonical_path_callee

EXTERN asm_esx_f_get_canonical_path

esx_f_get_canonical_path_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_esx_f_get_canonical_path
