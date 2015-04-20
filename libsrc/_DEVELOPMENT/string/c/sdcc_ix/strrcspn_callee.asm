
; size_t strrcspn_callee(const char *str, const char *cset)

SECTION code_string

PUBLIC _strrcspn_callee

_strrcspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strrcspn.asm"
