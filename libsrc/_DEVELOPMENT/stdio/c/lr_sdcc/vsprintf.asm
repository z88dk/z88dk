
; int vsprintf(char *s, const char *format, void *arg)

XDEF vsprintf

vsprintf:

   pop af
   pop bc
   pop de
   exx
   pop de
   
   push de
   exx
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_vsprintf.asm"
