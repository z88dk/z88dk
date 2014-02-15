
; size_t strrcspn(const char *str, const char *cset)

XDEF strrcspn

strrcspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_strrcspn.asm"
