
; char *fgets(char *s, int n, FILE *stream)

XLIB fgets

LIB asm_fgets

fgets:

   pop af
   pop ix
   pop bc
   pop de
   
   push de
   push bc
   push ix
   push af
   
   jp asm_fgets
