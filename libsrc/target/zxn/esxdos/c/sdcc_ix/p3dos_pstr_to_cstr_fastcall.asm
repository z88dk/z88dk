; unsigned char *p3dos_pstr_to_cstr(unsigned char *s)

SECTION code_esxdos

PUBLIC _p3dos_pstr_to_cstr_fastcall

EXTERN asm_p3dos_pstr_to_cstr

defc _p3dos_pstr_to_cstr_fastcall = asm_p3dos_pstr_to_cstr
