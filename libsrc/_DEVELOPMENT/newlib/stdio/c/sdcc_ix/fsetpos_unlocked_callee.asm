
; int fsetpos_unlocked_callee(FILE *stream, const fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fsetpos_unlocked_callee, l0_fsetpos_unlocked_callee

EXTERN asm_fsetpos_unlocked

_fsetpos_unlocked_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_fsetpos_unlocked_callee:

   push bc
   ex (sp),ix
   
   call asm_fsetpos_unlocked
   
   pop ix
   ret
