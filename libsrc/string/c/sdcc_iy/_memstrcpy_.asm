
; char *_memstrcpy_(void *p, char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC __memstrcpy_

EXTERN asm__memstrcpy

__memstrcpy_:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm__memstrcpy
