
; int vasprintf(char **ptr, const char *format, void *arg)

XDEF vasprintf

vasprintf:

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

   INCLUDE "../../z80/asm_vasprintf.asm"
