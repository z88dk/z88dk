
; int vfprintf(FILE *stream, const char *format, void *arg)

XDEF vfprintf_callee

vfprintf_callee:
   
   pop af
   pop bc
   pop de
   pop ix
   push af

   INCLUDE "../../z80/asm_vfprintf.asm"
