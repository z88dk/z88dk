
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fsetpos_unlocked

EXTERN asm_fsetpos_unlocked

_fsetpos_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_fsetpos_unlocked
