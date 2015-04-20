
; size_t strrspn_callee(const char *str, const char *cset)

SECTION code_string

PUBLIC _strrspn_callee

_strrspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strrspn.asm"
