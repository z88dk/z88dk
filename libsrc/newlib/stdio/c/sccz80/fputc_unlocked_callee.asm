
; int fputc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fputc_unlocked_callee

EXTERN asm_fputc_unlocked

fputc_unlocked_callee:

   pop hl
   pop de
   pop bc

   push ix
   push de
   pop ix
   ld e,c
   ex (sp),hl
   push hl

   call asm_fputc_unlocked
   pop ix
   ret
