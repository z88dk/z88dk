
; char *stpcpy(char * restrict s1, const char * restrict s2)

PUBLIC _stpcpy

_stpcpy:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_stpcpy.asm"
