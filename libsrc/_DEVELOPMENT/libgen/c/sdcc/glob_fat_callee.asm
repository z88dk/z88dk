; unsigned char glob_fat(const char *s, const char *pattern)

SECTION code_string

PUBLIC _glob_fat_callee
PUBLIC l0_glob_fat_callee

EXTERN asm_glob_fat

_glob_fat_callee:

   pop af
   pop hl
   pop de
   push af

l0_glob_fat_callee:

   call asm_glob_fat
   
   ld l,1
   ret nc                      ; return 1 for match
   
   dec l                       ; return 0 for no match
   ret
