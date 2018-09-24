; unsigned char glob(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob

EXTERN l0_glob_callee

glob:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_glob_callee
