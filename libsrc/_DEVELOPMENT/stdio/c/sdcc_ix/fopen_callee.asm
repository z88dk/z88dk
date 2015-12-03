
; FILE *fopen_callee(const char *filename, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fopen_callee, l0_fopen_callee

EXTERN asm_fopen

_fopen_callee:

   pop af
   pop hl
   pop de
   push af

l0_fopen_callee:

   push ix
   
   call asm_fopen
   
   pop ix
   ret
