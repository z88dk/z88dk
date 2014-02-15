
; size_t strrcspn(const char *str, const char *cset)

XDEF strrcspn

strrcspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_strrcspn.asm"
