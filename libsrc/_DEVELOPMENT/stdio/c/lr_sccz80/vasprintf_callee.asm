
; int vasprintf(char **ptr, const char *format, void *arg)

XDEF vasprintf_callee

vasprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop de
   exx
   push af
   
   INCLUDE "../../z80/asm_vasprintf.asm"
