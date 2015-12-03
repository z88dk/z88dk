
; int fgetpos_unlocked_callee(FILE *stream, fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetpos_unlocked_callee

EXTERN asm_fgetpos_unlocked

_fgetpos_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   jp asm_fgetpos_unlocked
