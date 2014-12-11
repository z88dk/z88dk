
; void *memset(void *s, int c, size_t n)

SECTION code_string

PUBLIC _memset

_memset:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_memset.asm"
