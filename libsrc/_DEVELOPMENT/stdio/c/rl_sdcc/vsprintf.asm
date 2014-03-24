
; int vsprintf(char *s, const char *format, void *arg)

XDEF vsprintf

vsprintf:

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
   
   push ix
   
   call asm_vsprintf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vsprintf.asm"
