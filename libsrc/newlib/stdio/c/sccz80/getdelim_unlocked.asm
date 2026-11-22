
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC getdelim_unlocked

EXTERN asm_getdelim_unlocked

getdelim_unlocked:

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push hl
   push af

   jp asm_getdelim_unlocked
