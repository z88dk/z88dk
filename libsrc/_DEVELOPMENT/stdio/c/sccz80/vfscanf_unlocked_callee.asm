
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

SECTION seg_code_stdio

PUBLIC vfscanf_unlocked_callee

vfscanf_unlocked_callee:

   pop af
   pop bc
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_vfscanf_unlocked.asm"
