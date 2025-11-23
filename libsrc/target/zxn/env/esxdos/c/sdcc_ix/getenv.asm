; char *getenv(const char *name)

SECTION code_env

PUBLIC _getenv

EXTERN _getenv_fastcall

_getenv:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _getenv_fastcall
