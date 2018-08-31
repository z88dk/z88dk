; unsigned char esx_f_get_canonical_path(char *pathname, char *canonical)

SECTION code_esxdos

PUBLIC esx_f_get_canonical_path

EXTERN asm_esx_f_get_canonical_path

esx_f_get_canonical_path:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_esx_f_get_canonical_path
