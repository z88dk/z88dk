
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

XLIB getdelim

LIB asm_getdelim

getdelim:

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push ix
   push af
   
   jp asm_getdelim
