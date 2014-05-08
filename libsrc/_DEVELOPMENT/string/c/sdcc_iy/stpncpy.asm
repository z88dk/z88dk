
; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)

PUBLIC _stpncpy

_stpncpy:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_stpncpy.asm"
