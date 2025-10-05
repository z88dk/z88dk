
; int fgetpos_unlocked_callee(FILE *stream, fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetpos_unlocked_callee, l0_fgetpos_unlocked_callee

EXTERN asm_fgetpos_unlocked

_fgetpos_unlocked_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_fgetpos_unlocked_callee:

   push bc
   ex (sp),ix
   
   call asm_fgetpos_unlocked
   
   pop ix
   ret
