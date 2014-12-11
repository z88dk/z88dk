
; size_t strrcspn(const char *str, const char *cset)

SECTION code_string

PUBLIC _strrcspn

_strrcspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strrcspn.asm"
