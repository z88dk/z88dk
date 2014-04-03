
; char *_memlwr_(void *p, size_t n)

XDEF _memlwr__callee

_memlwr__callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm__memlwr.asm"
