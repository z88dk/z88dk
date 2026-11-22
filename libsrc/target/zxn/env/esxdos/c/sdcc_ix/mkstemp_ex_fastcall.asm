; unsigned char mkstemp_ex(char *template)

SECTION code_env

PUBLIC _mkstemp_ex_fastcall

EXTERN asm_mkstemp_ex

_mkstemp_ex_fastcall:

   push ix
   push iy
   
   call asm_mkstemp_ex
   
   pop iy
   pop ix

   ret
