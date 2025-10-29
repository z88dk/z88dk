; char *getenv(const char *name)

SECTION code_env

PUBLIC _getenv_fastcall

EXTERN asm_getenv

_getenv_fastcall:

   push iy
   
   call asm_getenv
   
   pop iy
   ret
