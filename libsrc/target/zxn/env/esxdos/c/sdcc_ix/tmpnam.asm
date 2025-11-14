; char *tmpnam(char *s)

SECTION code_env

PUBLIC _tmpnam

EXTERN _tmpnam_fastcall

_tmpnam:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _tmpnam_fastcall
