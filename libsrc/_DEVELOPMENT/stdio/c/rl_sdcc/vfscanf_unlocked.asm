
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)

XDEF vfscanf_unlocked

vfscanf_unlocked:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   push ix
   
   ld ixl,e
   ld ixh,d
   
   ex de,hl
   call asm_vfscanf_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_vfscanf_unlocked.asm"
