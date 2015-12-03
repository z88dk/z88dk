
; char *_memupr__callee(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC __memupr__callee

EXTERN asm__memupr

__memupr_:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm__memupr
