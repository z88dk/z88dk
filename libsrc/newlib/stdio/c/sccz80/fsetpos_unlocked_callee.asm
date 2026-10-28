
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

SECTION code_clib
SECTION code_stdio

PUBLIC fsetpos_unlocked_callee

EXTERN asm_fsetpos_unlocked

fsetpos_unlocked_callee:

   pop hl
   pop de
   pop bc

   push ix
   push bc
   pop ix
   ex (sp),hl
   push hl
   ex de,hl

   call asm_fsetpos_unlocked
   pop ix
   ret
