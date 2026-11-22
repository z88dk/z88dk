
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _freopen_unlocked

EXTERN l0_freopen_unlocked_callee

_freopen_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_freopen_unlocked_callee
