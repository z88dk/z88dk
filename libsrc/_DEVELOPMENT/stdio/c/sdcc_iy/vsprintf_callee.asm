
; int vsprintf_callee(char *s, const char *format, void *arg)

SECTION code_stdio

PUBLIC _vsprintf_callee

_vsprintf_callee:

   pop af
   exx
   pop de
   exx
   pop de
   pop bc
   push af
   
   INCLUDE "stdio/z80/asm_vsprintf.asm"
