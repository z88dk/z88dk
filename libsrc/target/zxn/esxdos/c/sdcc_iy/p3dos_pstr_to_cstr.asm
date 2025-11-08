; unsigned char *p3dos_pstr_to_cstr(unsigned char *s)

SECTION code_esxdos

PUBLIC _p3dos_pstr_to_cstr

EXTERN asm_p3dos_pstr_to_cstr

_p3dos_pstr_to_cstr:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_p3dos_pstr_to_cstr
