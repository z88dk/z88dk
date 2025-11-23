; unsigned char esx_f_get_canonical_path(char *pathname, char *canonical)

SECTION code_esxdos

PUBLIC _esx_f_get_canonical_path

EXTERN l_esx_f_get_canonical_path_callee

_esx_f_get_canonical_path:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l_esx_f_get_canonical_path_callee
