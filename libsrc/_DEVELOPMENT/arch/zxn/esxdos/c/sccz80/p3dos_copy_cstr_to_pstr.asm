; unsigned char *p3dos_copy_cstr_to_pstr(char *pdst, const char *csrc)

SECTION code_esxdos

PUBLIC p3dos_copy_cstr_to_pstr

EXTERN asm_p3dos_copy_cstr_to_pstr

p3dos_copy_cstr_to_pstr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_p3dos_copy_cstr_to_pstr
