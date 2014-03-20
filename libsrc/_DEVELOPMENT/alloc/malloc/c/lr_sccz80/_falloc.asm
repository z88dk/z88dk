
; void *_falloc(void *p, size_t size)

XLIB _falloc

LIB asm__falloc

_falloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm__falloc
