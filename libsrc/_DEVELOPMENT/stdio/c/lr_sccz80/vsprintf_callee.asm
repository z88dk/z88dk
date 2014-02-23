
; int vsprintf(char *s, const char *format, void *arg)

XDEF vsprintf_callee

vsprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop de
   exx
   push af
   
   INCLUDE "../../z80/asm_vsprintf.asm"
