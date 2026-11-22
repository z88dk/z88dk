; char *getenv_ex(const char *filename, const char *name)

SECTION code_env

PUBLIC _getenv_ex

EXTERN l0_getenv_ex_callee

_getenv_ex:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_getenv_ex_callee
