
; size_t strrspn(const char *str, const char *cset)

XDEF strrspn

strrspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_strrspn.asm"
