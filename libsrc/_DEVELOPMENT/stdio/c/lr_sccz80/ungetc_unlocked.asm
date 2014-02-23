
; int ungetc_unlocked(int c, FILE *stream)

XLIB ungetc_unlocked

LIB asm_ungetc_unlocked

ungetc_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   jp asm_ungetc_unlocked
