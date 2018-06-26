; char *tmpnam(char *s)

SECTION code_env

PUBLIC _tmpnam_fastcall

EXTERN asm_tmpnam

_tmpnam_fastcall:

   push iy
   
   call asm_tmpnam
   
   pop iy
   ret
