
; int fseek_unlocked(FILE *stream, long offset, int whence)

XLIB fseek_unlocked

LIB asm_fseek_unlocked

fseek_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   
   push ix
   push de
   push hl
   push bc
   push af
   
   jp asm_fseek_unlocked
