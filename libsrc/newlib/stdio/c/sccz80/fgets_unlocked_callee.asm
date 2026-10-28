
; char *fgets(char *s, int n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fgets_unlocked_callee

EXTERN asm_fgets_unlocked

fgets_unlocked_callee:

   pop hl
   pop af
   pop bc
   pop de

   push ix
   push af
   pop ix
   ex (sp),hl
   push hl

   call asm_fgets_unlocked
   pop ix
   ret
