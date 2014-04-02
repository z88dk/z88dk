
; int fputc(int c, FILE *stream)

XDEF _fputc

_fputc:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fputc
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputc.asm"
