; unsigned char *p3dos_cstr_to_pstr(unsigned char *s)

SECTION code_esxdos

PUBLIC _p3dos_cstr_to_pstr

EXTERN asm_p3dos_cstr_to_pstr

_p3dos_cstr_to_pstr:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_p3dos_cstr_to_pstr
