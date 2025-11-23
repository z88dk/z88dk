
; int vopen(const char *path, int oflag, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC vopen

EXTERN asm_vopen

vopen:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_vopen
