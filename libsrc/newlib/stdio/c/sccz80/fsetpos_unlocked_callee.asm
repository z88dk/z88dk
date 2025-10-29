
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC fsetpos_unlocked_callee

EXTERN asm_fsetpos_unlocked

fsetpos_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af
   
   jp asm_fsetpos_unlocked
