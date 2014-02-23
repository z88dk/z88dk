
; int vfscanf(FILE *stream, const char *format, void *arg)

XDEF vfscanf_callee

vfscanf_callee:

   pop af
   pop bc
   pop de
   pop ix
   push af
   
   INCLUDE "../../z80/asm_vfscanf.asm"
