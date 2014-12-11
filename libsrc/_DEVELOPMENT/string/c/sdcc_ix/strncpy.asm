
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC _strncpy

_strncpy:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strncpy.asm"
