
; int vsnprintf(char *s, size_t n, const char *format, void *arg)

XDEF vsnprintf

vsnprintf:

   pop af
   pop bc
   pop de
   exx
   pop bc
   pop de
   
   push de
   push bc
   exx
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_vsnprintf.asm"
