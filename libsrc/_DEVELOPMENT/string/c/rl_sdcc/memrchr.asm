
; void *memrchr(const void *s, int c, size_t n)

XDEF memrchr

memrchr:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld a,e
   
   INCLUDE "../../z80/asm_memrchr.asm"
