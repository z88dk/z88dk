; char *tmpnam_ex(char *template)

SECTION code_env

PUBLIC _tmpnam_ex_fastcall

EXTERN asm_tmpnam_ex

_tmpnam_ex_fastcall:

   push ix
   push iy
   
   call asm_tmpnam_ex
   
   pop iy
   pop ix
   
   ret
