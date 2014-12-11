
; int vasprintf(char **ptr, const char *format, void *arg)

SECTION code_stdio

PUBLIC vasprintf_callee

vasprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop de
   exx
   push af
   
   INCLUDE "stdio/z80/asm_vasprintf.asm"
