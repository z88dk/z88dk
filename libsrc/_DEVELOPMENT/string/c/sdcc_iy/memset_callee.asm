
; void *memset_callee(void *s, int c, size_t n)

SECTION code_string

PUBLIC _memset_callee

_memset_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "string/z80/asm_memset.asm"
