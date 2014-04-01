
; int vasprintf(char **ptr, const char *format, void *arg)

XDEF vasprintf

vasprintf:

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
   
   INCLUDE "stdio/z80/asm_vasprintf.asm"
