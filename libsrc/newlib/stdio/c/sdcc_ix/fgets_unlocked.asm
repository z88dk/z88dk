
; char *fgets_unlocked(char *s, int n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgets_unlocked

EXTERN l0_fgets_unlocked_callee

_fgets_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af

   jp l0_fgets_unlocked_callee
