
; char *_memstrcpy(void *p, char *s, size_t n)

XDEF _memstrcpy_callee

_memstrcpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm__memstrcpy.asm"
