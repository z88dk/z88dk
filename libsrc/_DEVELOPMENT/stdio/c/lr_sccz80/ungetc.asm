
; int ungetc(int c, FILE *stream)

XLIB ungetc

LIB asm_ungetc

ungetc:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   jp asm_ungetc
