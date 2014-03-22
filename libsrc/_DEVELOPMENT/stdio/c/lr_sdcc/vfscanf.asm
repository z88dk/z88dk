
; int vfscanf(FILE *stream, const char *format, void *arg)

XDEF vfscanf

vfscanf:

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
   
   ld ixl,c
   ld ixh,b
   
   call asm_vfscanf
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_vfscanf.asm"
