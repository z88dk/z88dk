
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetpos_unlocked

EXTERN asm_fgetpos_unlocked

_fgetpos_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_fgetpos_unlocked
