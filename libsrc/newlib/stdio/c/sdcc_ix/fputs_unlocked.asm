
; int fputs_unlocked(const char *s, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fputs_unlocked

EXTERN l0_fputs_unlocked_callee

_fputs_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_fputs_unlocked_callee
