
; char *_memupr(void *p, size_t n)

XLIB _memupr

LIB asm__memupr

_memupr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm__memupr
