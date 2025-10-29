
; int vsscanf(const char *s, const char *format, va_list arg)

SECTION code_clib
SECTION code_stdio

PUBLIC vsscanf_callee

EXTERN asm_vsscanf

vsscanf_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_vsscanf
