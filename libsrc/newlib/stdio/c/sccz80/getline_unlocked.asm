
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC getline_unlocked

EXTERN asm_getline_unlocked

getline_unlocked:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push hl
   push af
   
   jp asm_getline_unlocked
