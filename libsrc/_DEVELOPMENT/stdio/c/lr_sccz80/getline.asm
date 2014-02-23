
; size_t getline(char **lineptr, size_t *n, FILE *stream)

XLIB getline

LIB asm_getline

getline:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push ix
   push af
   
   jp asm_getline
