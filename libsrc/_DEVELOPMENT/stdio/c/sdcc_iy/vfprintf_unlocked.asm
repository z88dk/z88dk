
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

XDEF vfprintf_unlocked

vfprintf_unlocked:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_vfprintf_unlocked.asm"
