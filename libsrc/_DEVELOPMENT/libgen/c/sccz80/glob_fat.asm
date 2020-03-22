; unsigned char glob_fat(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob_fat

EXTERN l0_glob_fat_callee

glob_fat:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_glob_fat_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _glob_fat
defc _glob_fat = glob_fat
ENDIF

