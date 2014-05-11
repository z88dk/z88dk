
; char *_memstrcpy_(void *p, char *s, size_t n)

PUBLIC _memstrcpy_

EXTERN asm__memstrcpy

_memstrcpy_:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm__memstrcpy
