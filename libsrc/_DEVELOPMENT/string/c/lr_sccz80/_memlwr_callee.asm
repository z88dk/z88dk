
; char *_memlwr(void *p, size_t n)

XDEF _memlwr_callee

_memlwr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm__memlwr.asm"
