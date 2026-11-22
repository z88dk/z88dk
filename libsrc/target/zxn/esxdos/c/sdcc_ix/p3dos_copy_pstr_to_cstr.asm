; unsigned char *p3dos_copy_pstr_to_cstr(char *cdst, const char *psrc)

SECTION code_esxdos

PUBLIC _p3dos_copy_pstr_to_cstr

EXTERN asm_p3dos_copy_pstr_to_cstr

_p3dos_copy_pstr_to_cstr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_p3dos_copy_pstr_to_cstr
