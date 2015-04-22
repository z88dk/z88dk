
; int vsnprintf_callee(char *s, size_t n, const char *format, void *arg)

SECTION code_stdio

PUBLIC _vsnprintf_callee, l0_vsnprintf_callee

_vsnprintf_callee:

   pop af
   exx
   pop de
   pop bc
   exx
   pop de
   pop bc
   push af

l0_vsnprintf_callee:

   push ix
   
   call asm_vsnprintf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vsnprintf.asm"
