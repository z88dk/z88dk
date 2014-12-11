
; size_t strrspn(const char *str, const char *cset)

SECTION code_string

PUBLIC _strrspn

_strrspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strrspn.asm"
