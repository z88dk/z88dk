; unsigned char mkstemp(char *template)

SECTION code_env

PUBLIC _env_mkstemp_fastcall

EXTERN asm_env_mkstemp

_env_mkstemp_fastcall:

   push ix
   push iy
   
   call asm_env_mkstemp
   
   pop iy
   pop ix

   ret
