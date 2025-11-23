
; size_t getline_unlocked_callee(char **lineptr, size_t *n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _getline_unlocked_callee

EXTERN asm_getline_unlocked

_getline_unlocked_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af
   
   jp asm_getline_unlocked
