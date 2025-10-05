
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _getline_unlocked

EXTERN l0_getline_unlocked_callee

_getline_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_getline_unlocked_callee
