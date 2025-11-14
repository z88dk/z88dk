
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetpos_unlocked

EXTERN l0_fgetpos_unlocked_callee

_fgetpos_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp l0_fgetpos_unlocked_callee
