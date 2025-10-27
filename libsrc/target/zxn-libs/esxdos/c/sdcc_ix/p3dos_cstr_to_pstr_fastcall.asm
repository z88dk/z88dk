; unsigned char *p3dos_cstr_to_pstr(unsigned char *s)

SECTION code_esxdos

PUBLIC _p3dos_cstr_to_pstr_fastcall

EXTERN asm_p3dos_cstr_to_pstr

defc _p3dos_cstr_to_pstr_fastcall = asm_p3dos_cstr_to_pstr
