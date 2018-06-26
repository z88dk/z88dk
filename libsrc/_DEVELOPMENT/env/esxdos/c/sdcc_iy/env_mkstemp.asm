; unsigned char mkstemp(char *template)

SECTION code_env

PUBLIC _env_mkstemp

EXTERN _env_mkstemp_fastcall

_env_mkstemp:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _env_mkstemp_fastcall
