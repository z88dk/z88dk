
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

XDEF vfprintf_unlocked

vfprintf_unlocked:

   pop af
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push bc
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_vfprintf_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_vfprintf_unlocked.asm"
