; unsigned char glob(const char *s, const char *pattern)

SECTION code_string

PUBLIC _glob_callee
PUBLIC l0_glob_callee

EXTERN asm_glob

_glob_callee:

   pop af
   pop hl
   pop de
   push af

l0_glob_callee:

   call asm_glob
   
   ld l,1
   ret nc                      ; return 1 for match
   
   dec l                       ; return 0 for no match
   ret
