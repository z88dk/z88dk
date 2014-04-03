
; void *_falloc_(void *p, size_t size)

XLIB _falloc_

LIB asm__falloc

_falloc_:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm__falloc
