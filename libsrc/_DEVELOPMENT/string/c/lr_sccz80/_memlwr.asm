
; char *_memlwr(void *p, size_t n)

XLIB _memlwr

LIB asm__memlwr

_memlwr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm__memlwr
