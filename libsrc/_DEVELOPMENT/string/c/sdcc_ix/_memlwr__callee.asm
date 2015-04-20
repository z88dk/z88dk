
; char *_memlwr__callee(void *p, size_t n)

SECTION code_string

PUBLIC __memlwr__callee

__memlwr_:

   pop af
   pop hl
   pop bc
   push af
      
   INCLUDE "string/z80/asm__memlwr.asm"
