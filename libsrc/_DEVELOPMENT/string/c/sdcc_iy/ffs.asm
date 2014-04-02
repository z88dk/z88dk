
; int ffs(int i)

XDEF _ffs

_ffs:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_ffs.asm"
