; unsigned char *p3dos_copy_pstr_to_cstr(char *cdst, const char *psrc)

SECTION code_esxdos

PUBLIC _p3dos_copy_pstr_to_cstr_callee

EXTERN asm_p3dos_copy_pstr_to_cstr

_p3dos_copy_pstr_to_cstr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_p3dos_copy_pstr_to_cstr
