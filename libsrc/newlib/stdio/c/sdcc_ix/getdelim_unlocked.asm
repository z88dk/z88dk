
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _getdelim_unlocked

EXTERN l0_getdelim_unlocked_callee

_getdelim_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   
   push bc
   push bc
   push de
   push hl
   push af

   jp l0_getdelim_unlocked_callee
