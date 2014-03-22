
; int fputc(int c, FILE *stream)

XLIB fputc

LIB asm_fputc

fputc:

   pop af
   pop ix
   pop de
   
   push de
   push ix
   push af
   
   jp asm_fputc
