
; char *strndup(const char *s, size_t n)

XDEF strndup

strndup:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "string/z80/asm_strndup.asm"
