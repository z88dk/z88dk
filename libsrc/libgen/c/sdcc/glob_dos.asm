; unsigned char glob_dos(const char *s, const char *pattern)

SECTION code_string

PUBLIC _glob_dos

EXTERN l0_glob_dos_callee

_glob_dos:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_glob_dos_callee
