
; char *_memlwr_(void *p, size_t n)

XLIB _memlwr_

LIB asm__memlwr

_memlwr_:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm__memlwr
