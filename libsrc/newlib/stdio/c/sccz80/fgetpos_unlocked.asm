
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC fgetpos_unlocked

EXTERN asm_fgetpos_unlocked

fgetpos_unlocked:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   jp asm_fgetpos_unlocked
