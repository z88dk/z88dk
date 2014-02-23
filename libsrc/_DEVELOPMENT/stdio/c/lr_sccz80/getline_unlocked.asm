
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

XLIB getline_unlocked

LIB asm_getline_unlocked

getline_unlocked:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push ix
   push af
   
   jp asm_getline_unlocked
