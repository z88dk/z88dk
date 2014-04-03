
; char *_memupr_(void *p, size_t n)

XLIB _memupr_

LIB asm__memupr

_memupr_:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm__memupr
