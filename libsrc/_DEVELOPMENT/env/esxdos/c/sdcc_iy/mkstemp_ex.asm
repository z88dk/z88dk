; unsigned char mkstemp_ex(char *template)

SECTION code_env

PUBLIC _mkstemp_ex

EXTERN _mkstemp_ex_fastcall

_mkstemp_ex:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _mkstemp_ex_fastcall
