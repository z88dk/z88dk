
; int vsprintf(char *s, const char *format, void *arg)

SECTION code_stdio

PUBLIC vsprintf_callee

vsprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop de
   exx
   push af
   
   INCLUDE "stdio/z80/asm_vsprintf.asm"
