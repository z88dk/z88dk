; unsigned char glob_dos(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob_dos

EXTERN l0_glob_dos_callee

glob_dos:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_glob_dos_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _glob_dos
defc _glob_dos = glob_dos
ENDIF

