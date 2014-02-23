
; int fputc(int c, FILE *stream)

XDEF fputc, putc

fputc:
putc:

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

   INCLUDE "../../z80/asm_fputc.asm"
