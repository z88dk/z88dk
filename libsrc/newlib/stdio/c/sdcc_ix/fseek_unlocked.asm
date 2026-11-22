
; int fseek_unlocked(FILE *stream, long offset, int whence)

SECTION code_clib
SECTION code_stdio

PUBLIC _fseek_unlocked

EXTERN l0_fseek_unlocked_callee

_fseek_unlocked:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push bc
   push af

   jp l0_fseek_unlocked_callee
