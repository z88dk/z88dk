
; int vsnprintf(char *s, size_t n, const char *format, void *arg)

SECTION code_stdio

PUBLIC _vsnprintf

_vsnprintf:

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
   
   INCLUDE "stdio/z80/asm_vsnprintf.asm"
