
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

XDEF vfscanf_unlocked

vfscanf_unlocked:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_vfscanf_unlocked.asm"
