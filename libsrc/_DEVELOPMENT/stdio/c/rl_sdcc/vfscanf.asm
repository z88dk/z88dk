
; int vfscanf(FILE *stream, const char *format, void *arg)

XDEF vfscanf

vfscanf:

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
   call asm_vfscanf
   
   pop ix
   ret

   INCLUDE "../../z80/asm_vfscanf.asm"
