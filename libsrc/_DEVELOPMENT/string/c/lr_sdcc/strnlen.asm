
; size_t strnlen(const char *s, size_t maxlen)

XDEF strnlen

strnlen:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_strnlen.asm"
