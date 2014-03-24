
; int fputc(int c, FILE *stream)

XDEF fputc

fputc:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fputc
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputc.asm"
