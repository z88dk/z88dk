
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC fsetpos_unlocked

EXTERN asm_fsetpos_unlocked

fsetpos_unlocked:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_fsetpos_unlocked
