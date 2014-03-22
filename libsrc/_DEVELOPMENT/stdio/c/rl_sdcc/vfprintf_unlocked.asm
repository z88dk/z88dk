
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

XDEF vfprintf_unlocked

vfprintf_unlocked:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   
   push bc
   push de
   exx
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_vfprintf_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_vfprintf_unlocked.asm"
