
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _getline_unlocked

EXTERN asm_getline_unlocked

_getline_unlocked:

   pop af
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push af
   
   jp asm_getline_unlocked
