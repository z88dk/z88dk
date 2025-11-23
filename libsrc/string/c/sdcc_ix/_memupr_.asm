
; char *_memupr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC __memupr_

EXTERN asm__memupr

__memupr_:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm__memupr
