
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

SECTION seg_code_stdio

PUBLIC _vfscanf_unlocked

_vfscanf_unlocked:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_vfscanf_unlocked.asm"
