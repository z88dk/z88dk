
; char *_memstrcpy(void *p, char *s, size_t n)

XDEF _memstrcpy

_memstrcpy:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "string/z80/asm__memstrcpy.asm"

