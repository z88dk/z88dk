
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fsetpos_unlocked

EXTERN l0_fsetpos_unlocked_callee

_fsetpos_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp l0_fsetpos_unlocked_callee
