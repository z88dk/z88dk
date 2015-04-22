
; int vsscanf_callee(const char *s, const char *format, va_list arg)

SECTION code_stdio

PUBLIC _vsscanf_callee, l0_vsscanf_callee

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
   
   INCLUDE "stdio/z80/asm_vsscanf.asm"
