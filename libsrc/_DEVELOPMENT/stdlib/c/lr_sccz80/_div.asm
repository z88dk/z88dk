
; void _div(div_t *d, int numer, int denom)

XLIB _div

LIB asm__div

_div:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm__div
