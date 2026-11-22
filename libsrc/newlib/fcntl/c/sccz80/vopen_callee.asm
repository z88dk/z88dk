
; int vopen(const char *path, int oflag, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC vopen_callee

EXTERN asm_vopen

vopen_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_vopen
