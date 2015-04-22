
; int vasprintf_callee(char **ptr, const char *format, void *arg)

SECTION code_stdio

PUBLIC _vasprintf_callee, l0_vasprintf_callee

_vasprintf_callee:

   pop af
   exx
   pop de
   exx
   pop de
   pop bc
   push af

l0_vasprintf_callee:

   push ix
   
   call asm_vasprintf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vasprintf.asm"
