
; char *_memstrcpy__callee(void *p, char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC __memstrcpy__callee

EXTERN asm__memstrcpy

__memstrcpy__callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm__memstrcpy
