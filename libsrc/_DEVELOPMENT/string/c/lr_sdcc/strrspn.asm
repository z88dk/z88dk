
; size_t strrspn(const char *str, const char *cset)

XDEF strrspn

strrspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strrspn.asm"
