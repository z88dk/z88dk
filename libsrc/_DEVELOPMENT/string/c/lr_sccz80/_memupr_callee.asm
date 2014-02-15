
; char *_memupr(void *p, size_t n)

XDEF _memupr_callee

_memupr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm__memupr.asm"
