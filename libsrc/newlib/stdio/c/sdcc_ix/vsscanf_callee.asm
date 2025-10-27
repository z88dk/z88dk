
; int vsscanf_callee(const char *s, const char *format, va_list arg)

SECTION code_clib
SECTION code_stdio

PUBLIC _vsscanf_callee, l0_vsscanf_callee

EXTERN asm_vsscanf

_vsscanf_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_vsscanf_callee:

   push ix
   
   call asm_vsscanf
   
   pop ix
   ret
