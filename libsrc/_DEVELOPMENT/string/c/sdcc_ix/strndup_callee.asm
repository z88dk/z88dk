
; char *strndup_callee(const char *s, size_t n)

SECTION code_string

PUBLIC _strndup_callee

_strndup_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strndup.asm"
