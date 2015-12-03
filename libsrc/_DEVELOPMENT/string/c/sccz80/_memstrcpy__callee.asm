
; char *_memstrcpy_(void *p, char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memstrcpy__callee

EXTERN asm__memstrcpy

_memstrcpy__callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm__memstrcpy
