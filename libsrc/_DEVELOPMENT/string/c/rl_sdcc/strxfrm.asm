
; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)

XDEF strxfrm

strxfrm:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_strxfrm.asm"
