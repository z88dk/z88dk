; unsigned char glob(const char *s, const char *pattern)

SECTION code_string

PUBLIC _glob

EXTERN l0_glob_callee

_glob:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_glob_callee
