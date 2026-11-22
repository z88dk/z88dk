
; char *fgets_unlocked_callee(char *s, int n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgets_unlocked_callee, l0_fgets_unlocked_callee

EXTERN asm_fgets_unlocked

_fgets_unlocked_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

l0_fgets_unlocked_callee:

   push de
   ex (sp),ix
   
   ex de,hl
   call asm_fgets_unlocked
   
   pop ix
   ret
