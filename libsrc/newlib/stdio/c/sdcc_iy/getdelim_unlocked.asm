
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _getdelim_unlocked

EXTERN asm_getdelim_unlocked

_getdelim_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   
   push hl
   push bc
   push de
   push hl
   push af

   jp asm_getdelim_unlocked
