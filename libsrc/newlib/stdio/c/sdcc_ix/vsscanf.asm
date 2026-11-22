
; int vsscanf(const char *s, const char *format, va_list arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsscanf

EXTERN l0_vsscanf_callee

_vsscanf:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_vsscanf_callee
