
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_string

PUBLIC _rawmemchr

_rawmemchr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   ld a,c
   
   INCLUDE "string/z80/asm_rawmemchr.asm"
