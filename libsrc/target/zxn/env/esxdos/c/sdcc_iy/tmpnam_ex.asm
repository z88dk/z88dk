; char *tmpnam_ex(char *template)

SECTION code_env

PUBLIC _tmpnam_ex

EXTERN _tmpnam_ex_fastcall

_tmpnam_ex:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _tmpnam_ex_fastcall
