
; int fsetpos_unlocked_callee(FILE *stream, const fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fsetpos_unlocked_callee

EXTERN asm_fsetpos_unlocked

_fsetpos_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   jp asm_fsetpos_unlocked
