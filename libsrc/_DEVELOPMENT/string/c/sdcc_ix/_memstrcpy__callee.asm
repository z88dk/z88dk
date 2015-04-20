
; char *_memstrcpy__callee(void *p, char *s, size_t n)

SECTION code_string

PUBLIC __memstrcpy__callee

__memstrcpy__callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm__memstrcpy.asm"
