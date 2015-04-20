
; char *_memupr__callee(void *p, size_t n)

SECTION code_string

PUBLIC __memupr__callee

__memupr_:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm__memupr.asm"
