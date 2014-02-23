
; int fputc_unlocked(int c, FILE *stream)

XLIB fputc_unlocked
XDEF putc_unlocked

LIB asm_fputc_unlocked

fputc_unlocked:
putc_unlocked:

   pop af
   pop ix
   pop de
   
   push de
   push ix
   push af
   
   jp asm_fputc_unlocked
