; unsigned char glob_fat(const char *s, const char *pattern)

SECTION code_string

PUBLIC _glob_fat

EXTERN l0_glob_fat_callee

_glob_fat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_glob_fat_callee
