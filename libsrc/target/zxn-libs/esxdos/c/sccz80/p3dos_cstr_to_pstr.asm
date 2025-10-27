; unsigned char *p3dos_cstr_to_pstr(unsigned char *s)

SECTION code_esxdos

PUBLIC p3dos_cstr_to_pstr

EXTERN asm_p3dos_cstr_to_pstr

defc p3dos_cstr_to_pstr = asm_p3dos_cstr_to_pstr
