
; char *_memupr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memupr_

EXTERN asm__memupr

_memupr_:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm__memupr
