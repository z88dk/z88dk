
; int vsscanf_callee(const char *s, const char *format, va_list arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsscanf_callee

EXTERN asm_vsscanf

_vsscanf_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_vsscanf
