
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

XDEF strncat

strncat:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_strncat.asm"
