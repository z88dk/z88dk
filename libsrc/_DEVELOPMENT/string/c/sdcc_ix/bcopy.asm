
; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_string

PUBLIC _bcopy

_bcopy:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_bcopy

INCLUDE "string/z80/asm_bcopy.asm"
