
; void *memmove(void *s1, const void *s2, size_t n)

SECTION seg_code_string

PUBLIC _memmove

_memmove:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_memmove.asm"
