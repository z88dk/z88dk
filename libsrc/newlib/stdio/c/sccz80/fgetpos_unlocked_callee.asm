
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC fgetpos_unlocked_callee

EXTERN asm_fgetpos_unlocked

fgetpos_unlocked_callee:

   pop hl
   pop de
   pop bc

   push ix
   push bc
   pop ix
   ex (sp),hl
   push hl
   ex de,hl

   call asm_fgetpos_unlocked
   pop ix
   ret
