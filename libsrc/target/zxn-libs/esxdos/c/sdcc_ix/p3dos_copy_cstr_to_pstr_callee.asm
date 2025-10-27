; unsigned char *p3dos_copy_cstr_to_pstr(char *pdst, const char *csrc)

SECTION code_esxdos

PUBLIC _p3dos_copy_cstr_to_pstr_callee

EXTERN asm_p3dos_copy_cstr_to_pstr

_p3dos_copy_cstr_to_pstr_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_p3dos_copy_cstr_to_pstr
