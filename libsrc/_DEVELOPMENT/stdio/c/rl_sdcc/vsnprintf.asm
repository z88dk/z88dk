
; int vsnprintf(char *s, size_t n, const char *format, void *arg)

XDEF vsnprintf

vsnprintf:

   pop af
   exx
   pop de
   pop bc
   exx
   pop de
   pop bc
   
   push bc
   push de
   exx
   push bc
   push de
   exx
   push af
   
   INCLUDE "../../z80/asm_vsnprintf.asm"
