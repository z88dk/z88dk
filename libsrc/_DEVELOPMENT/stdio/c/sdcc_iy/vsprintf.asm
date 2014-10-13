
; int vsprintf(char *s, const char *format, void *arg)

SECTION seg_code_stdio

PUBLIC _vsprintf

_vsprintf:

   pop af
   exx
   pop de
   exx
   pop de
   pop bc
   
   push bc
   push de
   exx
   push de
   exx
   push af
   
   INCLUDE "stdio/z80/asm_vsprintf.asm"
