
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)

XDEF _freopen_unlocked

_freopen_unlocked:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_freopen_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_freopen_unlocked.asm"
