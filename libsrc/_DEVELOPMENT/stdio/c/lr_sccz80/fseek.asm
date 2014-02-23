
; int fseek(FILE *stream, long offset, int whence)

XLIB fseek

LIB asm_fseek

fseek:

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
   
   jp asm_fseek
