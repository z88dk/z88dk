
; size_t strnlen(const char *s, size_t maxlen)

XDEF strnlen

strnlen:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_strnlen.asm"
