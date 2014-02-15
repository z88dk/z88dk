
; char *_memstrcpy(void *p, char *s, size_t n)

XLIB _memstrcpy

LIB asm__memstrcpy

_memstrcpy:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm__memstrcpy
