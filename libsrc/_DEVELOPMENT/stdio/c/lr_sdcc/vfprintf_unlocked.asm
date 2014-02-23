
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)

XDEF vfprintf_unlocked

vfprintf_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   push ix
   
   ld ixl,e
   ld ixh,d
   
   ex de,hl
   call asm_vfprintf_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_vfprintf_unlocked.asm"
