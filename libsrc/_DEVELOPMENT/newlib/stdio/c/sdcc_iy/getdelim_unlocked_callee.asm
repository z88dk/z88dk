
; size_t getdelim_unlocked_callee(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _getdelim_unlocked_callee

EXTERN asm_getdelim_unlocked

_getdelim_unlocked_callee:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   push af

   jp asm_getdelim_unlocked
