
; int vsnprintf(char *s, size_t n, const char *format, void *arg)

SECTION code_stdio

PUBLIC vsnprintf_callee

vsnprintf_callee:

   pop af
   pop bc
   pop de
   exx
   pop bc
   pop de
   exx
   push af
   
   INCLUDE "stdio/z80/asm_vsnprintf.asm"
