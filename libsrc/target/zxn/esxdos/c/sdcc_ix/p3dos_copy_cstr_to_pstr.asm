; unsigned char *p3dos_copy_cstr_to_pstr(char *pdst, const char *csrc)

SECTION code_esxdos

PUBLIC _p3dos_copy_cstr_to_pstr

EXTERN asm_p3dos_copy_cstr_to_pstr

_p3dos_copy_cstr_to_pstr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_p3dos_copy_cstr_to_pstr
