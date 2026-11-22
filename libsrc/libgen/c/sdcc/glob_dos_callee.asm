; unsigned char glob_dos(const char *s, const char *pattern)

SECTION code_string

PUBLIC _glob_dos_callee
PUBLIC l0_glob_dos_callee

EXTERN asm_glob_dos

_glob_dos_callee:

   pop af
   pop hl
   pop de
   push af

l0_glob_dos_callee:

   call asm_glob_dos
   
   ld l,1
   ret nc                      ; return 1 for match
   
   dec l                       ; return 0 for no match
   ret
