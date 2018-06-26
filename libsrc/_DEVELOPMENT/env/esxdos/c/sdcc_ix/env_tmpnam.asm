; char *tmpnam(char *s)

SECTION code_env

PUBLIC _env_tmpnam

EXTERN _env_tmpnam_fastcall

_env_tmpnam:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _env_tmpnam_fastcall
