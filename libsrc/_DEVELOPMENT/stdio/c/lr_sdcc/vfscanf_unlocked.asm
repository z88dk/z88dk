
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

XDEF vfscanf_unlocked

vfscanf_unlocked:

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
   
   call asm_vfscanf_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_vfscanf_unlocked.asm"
