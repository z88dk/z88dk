
; size_t strnlen_callee(const char *s, size_t maxlen)

SECTION code_string

PUBLIC _strnlen_callee

_strnlen:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strnlen.asm"
