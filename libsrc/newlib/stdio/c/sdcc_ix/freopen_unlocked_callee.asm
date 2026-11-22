
; FILE *freopen_unlocked_callee(char *filename, char *mode, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _freopen_unlocked_callee, l0_freopen_unlocked_callee

EXTERN asm_freopen_unlocked

_freopen_unlocked_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_freopen_unlocked_callee:
   
   push bc
   ex (sp),ix
   
   call asm_freopen_unlocked
   
   pop ix
   ret
