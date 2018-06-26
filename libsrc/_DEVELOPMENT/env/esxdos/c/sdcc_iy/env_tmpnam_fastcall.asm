; char *tmpnam(char *s)

SECTION code_env

PUBLIC _env_tmpnam_fastcall

EXTERN asm_env_tmpnam

_env_tmpnam_fastcall:

   push iy
   
   call asm_env_tmpnam
   
   pop iy
   ret
