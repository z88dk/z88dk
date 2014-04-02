
; int vfscanf(FILE *stream, const char *format, void *arg)

XDEF _vfscanf

_vfscanf:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_vfscanf.asm"
