
; int fputc(int c, FILE *stream)

XLIB fputc
XDEF putc

LIB asm_fputc

fputc:
putc:

   pop af
   pop ix
   pop de
   
   push de
   push ix
   push af
   
   jp asm_fputc
