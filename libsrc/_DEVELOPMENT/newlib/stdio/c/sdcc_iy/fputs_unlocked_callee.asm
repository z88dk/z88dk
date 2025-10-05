
; int fputs_unlocked_callee(const char *s, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fputs_unlocked_callee

EXTERN asm_fputs_unlocked

_fputs_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af

   jp asm_fputs_unlocked
