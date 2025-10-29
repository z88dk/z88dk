
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC fgetpos_unlocked_callee

EXTERN asm_fgetpos_unlocked

fgetpos_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af
   
   jp asm_fgetpos_unlocked
