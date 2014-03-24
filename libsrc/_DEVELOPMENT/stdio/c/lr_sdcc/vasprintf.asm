
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
   
   push ix
   
   call asm_vasprintf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vasprintf.asm"
