
; void *memrchr(const void *s, int c, size_t n)

XDEF memrchr

memrchr:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   ld a,e
   
   INCLUDE "string/z80/asm_memrchr.asm"
