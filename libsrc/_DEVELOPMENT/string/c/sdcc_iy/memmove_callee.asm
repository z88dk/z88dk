
; void *memmove_callee(void *s1, const void *s2, size_t n)

SECTION code_string

PUBLIC _memmove_callee

_memmove_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_memmove.asm"
